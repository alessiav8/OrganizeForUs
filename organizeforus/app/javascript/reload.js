$(document.head).ready(function() {
    if(!!window.performance && window.performance.getEntriesByType("navigation")[0].type === "back_forward" ){  
  
  
        console.log('Reloading');
        
        
        window.location.reload();

    }
});