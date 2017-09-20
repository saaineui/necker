/* 
  * ActiveCharts 
  * ============
  * package for chart interactivity 
  * no dependencies
  * browser support: IE 9+, Firefox, Chrome, Safari
  */
  var ActiveCharts = (function() {
  
    var tooltip_triggers = [];
    var tooltips = [];
    
    function setTriggers(classNames) {
      for (var i = 0; i < classNames.length; i++) {
        tooltip_triggers.push.apply(tooltip_triggers, document.getElementsByClassName(classNames[i]));
      }
    }

    function setTooltips(classNames) {
      for (var i = 0; i < classNames.length; i++) {
        tooltips.push.apply(tooltips, document.getElementsByClassName(classNames[i]));
      }
    }
    
    function toggleTooltip(triggerEl, tooltipEl) {
      if (hasClass(triggerEl, 'ac-highlight')) {
        removeClass(triggerEl, 'ac-highlight');
        removeClass(tooltipEl, 'ac-visible');
      } else {
        addClass(triggerEl, 'ac-highlight');
        addClass(tooltipEl, 'ac-visible');
      }
    }

    function addClass(el, className) {
      if (el.classList)
        el.classList.add(className);
      else
        el.className += ' ' + className;
    }

    function removeClass(el, className) {
      if (el.classList)
        el.classList.remove(className);
      else
        el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
    }

    function hasClass(el, className) {
      if (el.classList)
        return el.classList.contains(className);
      else
        return new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className);
    }
    
    return {
      
      activateTooltips: function(triggerClassNames, tooltipClassNames, eventName) {
        setTriggers(triggerClassNames);
        setTooltips(tooltipClassNames)

        for (var i = 0; i < tooltip_triggers.length; i++) {
          tooltip_triggers[i].addEventListener(eventName, function(e){
            toggleTooltip(e.target, e.target.nextElementSibling);
          });
        }

        for (i = 0; i < tooltips.length; i++) {
          tooltips[i].addEventListener(eventName, function(e){
            toggleTooltip(e.target.previousElementSibling, e.target);
          });
        }
      },
      
      // expose some private methods
      toggleTooltip: toggleTooltip,
      addClass: addClass,
      removeClass: removeClass,
      hasClass: hasClass
      
    };
  
})();

ActiveCharts.activateTooltips(['ac-scatter-plot-dot'], ['ac-scatter-plot-label'], 'click');

