/**
 * Client-side script for the BiteSync Fast Food Web App.
 */

/**
 * Filters the food card items shown in the menu section based on their category.
 * Adds a fading transition effect when switching categories.
 * 
 * @param {string} category The food category to filter by (e.g. 'Burgers', 'Pizzas', 'all')
 * @param {HTMLElement} button The button element triggering the filter
 */
function filterMenu(category, button) {
    // Update active state of button tabs
    const tabs = document.querySelectorAll('.tab-btn');
    tabs.forEach(tab => tab.classList.remove('active'));
    button.classList.add('active');
    
    // Get all card elements
    const cards = document.querySelectorAll('.food-card');
    
    cards.forEach(card => {
        const cardCategory = card.getAttribute('data-category');
        
        // Hide cards with a fade-out effect first
        card.style.opacity = '0';
        card.style.transform = 'scale(0.95)';
        
        setTimeout(() => {
            if (category === 'all' || cardCategory === category) {
                card.style.display = 'flex';
                // Trigger reflow to animate opacity/transform
                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'scale(1)';
                }, 50);
            } else {
                card.style.display = 'none';
            }
        }, 300);
    });
}
