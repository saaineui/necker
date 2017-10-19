function activeChartsTrigger(el, eventName) {
  var event = new Event(eventName);
  try {
    el.dispatchEvent(event);
  }
  catch(e) {
    console.error(e);
  }
}

describe('ActiveCharts', function() {
  var body, chart;

  beforeEach(function() {
    body = document.getElementsByTagName('body')[0];
    
    chart = document.createElement('svg'); 
    chart.innerHTML = '<circle id="trigger" class="ac-scatter-plot-dot ac-triggerable series-a" />';
    chart.innerHTML += '<text id="tooltip" class="ac-scatter-plot-label ac-toggleable">Cats</text>';
    chart.innerHTML += '<circle class="ac-scatter-plot-dot ac-triggerable series-a" />';
    chart.innerHTML += '<text class="ac-scatter-plot-label ac-toggleable">Dogs</text>';
    chart.innerHTML += '<text id="orphan-tooltip" class="ac-scatter-plot-label ac-toggleable">Fish</text>';
    chart.className = 'ac-chart';
    
    body.appendChild(chart);
  });
  
  afterEach(function() {
    body.removeChild(chart);
  });
  
  it('#hasClass returns true if element has class', function() {
    expect(ActiveCharts.hasClass(chart, 'class-added')).toBe( false );
    expect(ActiveCharts.hasClass(chart, 'ac-chart')).toBe( true );
  });

  it('#addClass adds a class to an element', function() {
    ActiveCharts.addClass(chart, 'class-added')
    expect(ActiveCharts.hasClass(chart, 'class-added')).toBe( true );
  });

  it('#removeClass removes a class from an element', function() {
    ActiveCharts.removeClass(chart, 'ac-chart')
    expect(ActiveCharts.hasClass(chart, 'ac-chart')).toBe( false );
  });
  
  it ('#activateTooltips adds click events to tooltips and triggers', function() {
    ActiveCharts.activateTooltips(['ac-triggerable'], ['ac-toggleable'], 'mock-click');
    
    var tooltipTrigger = document.getElementById('trigger');
    var tooltip = document.getElementById('tooltip');
    var orphanTooltip = document.getElementById('orphan-tooltip');
    expect(ActiveCharts.hasClass(tooltipTrigger, 'ac-highlight')).toBe( false );
    expect(ActiveCharts.hasClass(tooltip, 'ac-visible')).toBe( false );
    
    activeChartsTrigger(tooltipTrigger, 'mock-click');
    expect(ActiveCharts.hasClass(tooltipTrigger, 'ac-highlight')).toBe( true );
    expect(ActiveCharts.hasClass(tooltip, 'ac-visible')).toBe( true );
    expect(document.getElementsByClassName('ac-highlight').length).toEqual( 1 );
    expect(document.getElementsByClassName('ac-visible').length).toEqual( 1 );
    
    activeChartsTrigger(tooltip, 'mock-click');
    expect(ActiveCharts.hasClass(tooltipTrigger, 'ac-highlight')).toBe( false );
    expect(ActiveCharts.hasClass(tooltip, 'ac-visible')).toBe( false );
    
    activeChartsTrigger(orphanTooltip, 'mock-click');
    expect(ActiveCharts.hasClass(tooltipTrigger, 'ac-highlight')).toBe( false );
    expect(ActiveCharts.hasClass(tooltip, 'ac-visible')).toBe( false );
    expect(ActiveCharts.hasClass(orphanTooltip, 'ac-visible')).toBe( true );
  });
});
