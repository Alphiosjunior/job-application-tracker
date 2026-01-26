// Dark Mode Toggle
const body = document.body;
const darkToggle = document.getElementById('darkToggle');

// Check for saved theme preference, default is dark (no class needed)
const currentTheme = localStorage.getItem('theme');
if (currentTheme === 'light') {
    body.classList.add('light-mode');
    darkToggle.textContent = '🌙';
} else {
    // Dark mode is default
    darkToggle.textContent = '☀️';
    if (!currentTheme) {
        localStorage.setItem('theme', 'dark');
    }
}

// Dark mode toggle event
darkToggle.addEventListener('click', () => {
    body.classList.toggle('light-mode');
    const isLight = body.classList.contains('light-mode');
    darkToggle.textContent = isLight ? '🌙' : '☀️';
    localStorage.setItem('theme', isLight ? 'light' : 'dark');
});

// ⚠️ IMPORTANT: Replace this with your actual API Gateway URL after deployment
const API_BASE_URL = 'https://22ya442iig.execute-api.af-south-1.amazonaws.com/dev/applications';

// DOM Elements
const applicationForm = document.getElementById('applicationForm');
const applicationsList = document.getElementById('applicationsList');
const loadingMessage = document.getElementById('loadingMessage');
const errorMessage = document.getElementById('errorMessage');
const emptyMessage = document.getElementById('emptyMessage');
const editModal = document.getElementById('editModal');
const editForm = document.getElementById('editForm');
const closeModal = document.querySelector('.close');

// Stats elements
const totalAppsElement = document.getElementById('totalApps');
const interviewingAppsElement = document.getElementById('interviewingApps');
const offerAppsElement = document.getElementById('offerApps');

// Initialize app
document.addEventListener('DOMContentLoaded', () => {
    loadApplications();
    setupEventListeners();
});

// Setup Event Listeners
function setupEventListeners() {
    applicationForm.addEventListener('submit', handleCreateApplication);
    editForm.addEventListener('submit', handleUpdateApplication);
    closeModal.addEventListener('click', closeEditModal);
    
    // Close modal when clicking outside
    window.addEventListener('click', (e) => {
        if (e.target === editModal) {
            closeEditModal();
        }
    });
}

// Load all applications
async function loadApplications() {
    try {
        showLoading(true);
        hideError();
        
        const response = await fetch(`${API_BASE_URL}`);
        
        if (!response.ok) {
            throw new Error('Failed to load applications');
        }
        
        const data = await response.json();
        const applications = data.applications || [];
        
        displayApplications(applications);
        updateStats(applications);
        
    } catch (error) {
        console.error('Error loading applications:', error);
        showError('Failed to load applications. Please check your API URL and try again.');
    } finally {
        showLoading(false);
    }
}

// Display applications
function displayApplications(applications) {
    if (applications.length === 0) {
        applicationsList.innerHTML = '';
        emptyMessage.style.display = 'block';
        return;
    }
    
    emptyMessage.style.display = 'none';
    
    applicationsList.innerHTML = applications.map(app => `
        <div class="application-card">
            <h3>${app.company}</h3>
            <p><strong>Position:</strong> ${app.position}</p>
            <span class="status ${app.status}">${app.status}</span>
            <p><strong>Date Applied:</strong> ${formatDate(app.date)}</p>
            <div class="application-actions">
                <button class="btn btn-edit" onclick="openEditModal('${app.applicationId}')">Edit</button>
                <button class="btn btn-delete" onclick="deleteApplication('${app.applicationId}')">Delete</button>
            </div>
        </div>
    `).join('');
}

// Update statistics
function updateStats(applications) {
    const total = applications.length;
    const interviewing = applications.filter(app => app.status === 'Interviewing').length;
    const offers = applications.filter(app => app.status === 'Offer').length;
    
    totalAppsElement.textContent = total;
    interviewingAppsElement.textContent = interviewing;
    offerAppsElement.textContent = offers;
}

// Create new application
async function handleCreateApplication(e) {
    e.preventDefault();
    
    const formData = new FormData(applicationForm);
    const application = {
        company: formData.get('company'),
        position: formData.get('position'),
        status: formData.get('status'),
        date: formData.get('date')
    };
    
    try {
        const response = await fetch(`${API_BASE_URL}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(application)
        });
        
        if (!response.ok) {
            throw new Error('Failed to create application');
        }
        
        // Reset form and reload applications
        applicationForm.reset();
        await loadApplications();
        
        // Show success message (optional)
        alert('Application added successfully! 🎉');
        
    } catch (error) {
        console.error('Error creating application:', error);
        showError('Failed to create application. Please try again.');
    }
}

// Open edit modal
async function openEditModal(applicationId) {
    try {
        const response = await fetch(`${API_BASE_URL}/${applicationId}`);
        
        if (!response.ok) {
            throw new Error('Failed to fetch application');
        }
        
        const data = await response.json();
        const app = data.application;
        
        // Populate form
        document.getElementById('editId').value = app.applicationId;
        document.getElementById('editCompany').value = app.company;
        document.getElementById('editPosition').value = app.position;
        document.getElementById('editStatus').value = app.status;
        document.getElementById('editDate').value = app.date;
        
        // Show modal
        editModal.style.display = 'block';
        
    } catch (error) {
        console.error('Error loading application:', error);
        showError('Failed to load application details.');
    }
}

// Close edit modal
function closeEditModal() {
    editModal.style.display = 'none';
    editForm.reset();
}

// Update application
async function handleUpdateApplication(e) {
    e.preventDefault();
    
    const applicationId = document.getElementById('editId').value;
    const formData = new FormData(editForm);
    
    const updatedApplication = {
        company: formData.get('company'),
        position: formData.get('position'),
        status: formData.get('status'),
        date: formData.get('date')
    };
    
    try {
        const response = await fetch(`${API_BASE_URL}/${applicationId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(updatedApplication)
        });
        
        if (!response.ok) {
            throw new Error('Failed to update application');
        }
        
        // Close modal and reload
        closeEditModal();
        await loadApplications();
        
        alert('Application updated successfully! ✅');
        
    } catch (error) {
        console.error('Error updating application:', error);
        showError('Failed to update application. Please try again.');
    }
}

// Delete application
async function deleteApplication(applicationId) {
    if (!confirm('Are you sure you want to delete this application?')) {
        return;
    }
    
    try {
        const response = await fetch(`${API_BASE_URL}/${applicationId}`, {
            method: 'DELETE'
        });
        
        if (!response.ok) {
            throw new Error('Failed to delete application');
        }
        
        await loadApplications();
        alert('Application deleted successfully! 🗑️');
        
    } catch (error) {
        console.error('Error deleting application:', error);
        showError('Failed to delete application. Please try again.');
    }
}

// Utility Functions
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
}

function showLoading(show) {
    loadingMessage.style.display = show ? 'block' : 'none';
}

function showError(message) {
    errorMessage.textContent = message;
    errorMessage.style.display = 'block';
}

function hideError() {
    errorMessage.style.display = 'none';
}