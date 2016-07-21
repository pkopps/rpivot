HTMLWidgets.widget({

    name: 'rpivot',

    type: 'output',

    initialize: function(el, width, height) {

	    return {};

    },

    renderValue: function(el, x, instance) {
	    x.data = HTMLWidgets.dataframeToD3(x.data);

	    var derivers = $.pivotUtilities.derivers;
     	//var tpl = $.pivotUtilities.aggregatorTemplates;
      
      // set locale to "en" which is the default for pivottable
      //  this eases code later
      if(typeof(x.locale) === "undefined") x.locale = "en";

      x.params.renderers = $.extend(
        $.pivotUtilities.locales[x.locale].renderers,
        $.pivotUtilities.d3_renderers,
        $.pivotUtilities.c3_renderers
      );

      // temporary hack to make Portuguese d3 and c3 renderers
      if(x.locale === "pt"){
        x.params.renderers["Mapa de Árvore"] = x.params.renderers["Treemap"];
        x.params.renderers["Gráfico de Linha"] = x.params.renderers["Line Chart"];
        x.params.renderers["Gráfico de Barras"] = x.params.renderers["Bar Chart"];
        x.params.renderers["Gráfico de Barras Empilhadas"] = x.params.renderers["Stacked Bar Chart"];
        x.params.renderers["Gráfico de Área"] = x.params.renderers["Area Chart"];
        x.params.renderers["Gráfico de Dispersão"] = x.params.renderers["Scatter Chart"];
        
        // delete the English
        delete(x.params.renderers["Treemap"]);
        delete(x.params.renderers["Line Chart"]);
        delete(x.params.renderers["Bar Chart"]);
        delete(x.params.renderers["Stacked Bar Chart"]);
        delete(x.params.renderers["Area Chart"]);
        delete(x.params.renderers["Scatter Chart"]);

      }

      if (typeof x.params.sorters != "undefined") {
      if (typeof x.params.sorters[0] == "string") {
          x.params.sorters = eval("("+x.params.sorters[0]+")")
        }
      }
    
      if (typeof x.params.onRefresh != "undefined") {
        x.params.onRefresh = x.params.onRefresh[0];
      }
     
     //(x.params.numberFormat) 
      
      $(function(){
      	
      	//var numsAfterDec = x.params.numsAfterDec;
	var utils = $.pivotUtilities;
	
	/*
	var functs = {
	        'Sum over Sum': $.pivotUtilities.aggregatorTemplates.sumOverSum,
	        Sum: $.pivotUtilities.aggregatorTemplates.sum,
	        Average: $.pivotUtilities.aggregatorTemplates.average,
        }
        */
	
	      $('#'+el.id).pivot(
	      		x.data,
	      		{    
	      		rows: x.params.rows,
    			cols: x.params.cols,
    			// TESTING aggregator
    			aggregator: utils.aggregatorTemplates[x.params.funct](x.params.numberFormat)(x.params.vals),
    			//aggregator: functs[x.params.funct](utils.numberFormat({digitsAfterDecimal: numsAfterDec}))(x.params.vals),
    			//aggregator: utils.aggregators[x.params.funct](x.params.vals),
    			renderer: utils.renderers[x.params.renderer]
	      		},
	      		true,
	      		x.locale
	      );
    });

    },

    resize: function(el, width, height, instance) {

    }

});
