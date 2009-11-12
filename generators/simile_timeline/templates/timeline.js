/* Make a little class to create a timeline from JSON.
*
* Example:
*
* new Timeline({
*   theme: 'ClassicTheme'
*   startDate: '1900-01-01'
*   stopDate: '2000-01-01'
*   timelineElement: 'tl',
*   url: '.'
*   bands: [{
*     intervalUnit: 'DECADE',
*     intervalPixels: 100,
*     date: '1900-01-01',
*     layout: 'original'
*     // syncWith: 0,
*     // highlight: true
*   }]},
*   timeline_data_as_json
* );
*
*/
function Timeline(params) {
	this.eventSource = params.eventSource
	this.create_theme(params.theme, params.startDate, params.stopDate)
	this.eventSource = new Timeline.DefaultEventSource();
	this.create_bands(params.bands)
	$(document).ready(function {
		tl_element = document.getElementById(params.timelineElement || 'tl')
		var timeline = Timeline.create(tl_element, this.bands, Timeline.HORIZONTAL)
		this.eventSource.loadJSON(params.data, params.url || '.')
		timeline.layout(); 
	}

	var resizeTimerID = null;
	$(window).resize(function() {
		if (resizeTimerID == null) {
			resizeTimerID = window.setTimeout(function() {
				resizeTimerID = null;
				timeline.layout();
				}, 500);
			}
		});

		// Create the theme
		this.prototype.create_theme = function(theme, start, stop) {
			theme = Timeline[theme || 'ClassicTheme'].create();
			theme.timeline_start = Timeline.DateTime.parseIso8601DateTime(start || '1900')
			theme.timeline_stop = Timeline.DateTime.parseIso8601DateTime(stop || '2000')
			this.theme = theme
		}

		// Create the band objects
		this.prototype.create_bands = function(bands) {
			this.bands = new Array();
			// Go through all bands
			for(band in bands) {
				new_band = new Object();
				new_band.width = 70;
				new_band.intervalUnit = Timeline.DateTime[band.intervalUnit || 'DECADE'];
				new_band.intervalPixels = (band.intervalPixels || '100');
				new_band.eventSource = this.eventSource;
				new_band.date = Timeline.DateTime.parseIso8601DateTime(band.date || '1900');
				new_band.theme = this.theme;
				new_band.layout = (band.layout || 'original');
				if(band.syncWith) { new_band.syncWith = band.syncWith; }
				if(band.highlight) { new_band.highlight = band.highlight; }
				this.bands.concat(Timeline.createBandInfo(new_band));
			}
		}
	}
