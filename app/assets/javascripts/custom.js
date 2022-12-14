$(document).ready(function() {

    // Main Input Text Data Table for sorting/filtering/ and exporting shingles
    var table = $('#my-table').DataTable({

        /*ajax: { url: '/update_token_table',
                  type: 'POST',
                  data: {"text":data},
                  dataSrc: ''            },*/

        dom: 'RPlfrtipB',
        searchPane:true,
        searchPanes:{
			cascadePanes: true,

            dtOpts: {
                select: {
                    style: 'multi'
                }
            }
        },

        order: [[3,'desc']],

        fixedColumns: {
            left: 1
        },

        // Name the columns to make things more readable later
        columns: [
            { name: 'word' },        
            { name: 'index' },
            { name: 'count' },
            { name: 'frequency' },
            { name: 'hsk' },
            { name: 'type' },
            { name: 'garbage' },
            { name: 'mark'},
        ],

        /*columns: [
            { data: 'index' },
            { data: 'word' },
            { data: 'count' },
            { data: 'freq' },
            { data: 'hsk' },
            { data: 'type' },
            { data: 'garbage' },
            { data: 'mark' },
            ],
        */

        // order: [[0,'asc']],
        // order: [[2,'desc'],[ 3, 'desc' ]],
        // destroy: true,
        // scrollX: true,
        // stateSave: true,        

	    language: {
	        search: "_INPUT_",
	        searchPlaceholder: "Search...",
	        lengthMenu:'<select>'+
		      '<option value="10">10</option>'+
		      '<option value="20">20</option>'+
		      '<option value="50">50</option>'+
		      '<option value="100">100</option>'+
		      '</select>'
	    },

        // Configure the export buttons
        buttons: [
            // Pleco Export Option (saves as csv, but it doesn't matter)
            {
                extend: 'csv',
                //Name the CSV - will change to the name of the input text later
                filename: $("#input-text-title").text(),
                text: 'Pleco',
                //extension:'.txt',
                exportOptions: {
                        columns: ["word:name"] //$("#area_column")
                },
                //Function which customize the CSV (input : csv is the object that you can preprocesss)
                customize: function (csv) {

                        //Split the csv to get the rows
                        var split_csv = csv.split("\n");
 
                        //Remove the row one to personnalize the headers
                        split_csv[0] = "\uFEFF"+"// "+$("#input-text-title").text()
 
                        //For each row except the first one (header)
                        $.each(split_csv.slice(1), function (index, csv_row) {

                                //Split on quotes and comma to get each cell
                                var csv_cell_array = csv_row.split('","');
 
                                //Remove replace the two quotes which are left at the beginning and the end (first and last cell)
                                csv_cell_array[0] = csv_cell_array[0].replace(/"/g, '');
                                //csv_cell_array[1] = csv_cell_array[1].replace(/"/g, '');
  
                                //Join the table on the quotes and comma; add back the quotes at the beginning and end
                                csv_cell_array_quotes = csv_cell_array.join('\t');
 
                                //Insert the new row into the rows array at the previous index (index +1 because the header was sliced)
                                split_csv[index + 1] = csv_cell_array_quotes;
                        });
 
                        //Join the rows with line break and return the final csv (datatables will take the returned csv and process it)
                        csv = split_csv.join("\n");
                        return csv;
                }
            },

            {
                extend:'csv',
                filename: $("#input-text-title").text(),
                customize:function(csv){return "\uFEFF"+csv} //So that csv opens with correct encoding in excel
            },
            'copy',
            {extend:'excel',filename: $("#input-text-title").text(),},
        ],

        columnDefs:[

        	// Count Column
            {
                searchPanes:{
                	initCollapsed: true,
                },
                targets:[2]
            },

            //Frequency Column
            {
                searchPanes:{
                	threshold:1,
                	show:true,
                	initCollapsed:true,
                    options:[

                        { 	label:'20+',
                            value: function(rowData,rowIdx){
                                return rowData[3]>20; 					}	},
                        {	label:'19-20',
                            value: function(rowData,rowIdx){
                                return rowData[3]>=19 && rowData[3]<20;	}	},
                        {	label:'18-19',
                            value: function(rowData,rowIdx){
                                return rowData[3]>=18 && rowData[3]<19;	}	},
                        {	label:'17-18',
                            value: function(rowData,rowIdx){
                                return rowData[3]>=17 && rowData[3]<18;	}	},
                        {	label:'16-17',
                            value: function(rowData,rowIdx){
                                return rowData[3]>=16 && rowData[3]<17;	}	},
                        {	label:'15-16',
                            value: function(rowData,rowIdx){
                                return rowData[3]>=15 && rowData[3]<16;	}	},
                        {	label:'14-15',
                            value: function(rowData,rowIdx){
                                return rowData[3]>=14 && rowData[3]<15;	}	},
                        {	label:'13-14',
                            value: function(rowData,rowIdx){
                                return rowData[3]>=13 && rowData[3]<14;	}	},
                        {	label:'12-13',
                            value: function(rowData,rowIdx){
                                return rowData[3]>=12 && rowData[3]<13;	}	},
                        {	label:'11-12',
                            value: function(rowData,rowIdx){
                                return rowData[3]>=11 && rowData[3]<12;	}	},
                        {	label:'10-11',
                            value: function(rowData,rowIdx){
                                return rowData[3]>=10 && rowData[3]<11;	}	},
                        {	label:'10-',
                            value: function(rowData,rowIdx){
                                return rowData[3]>=0 && rowData[3]<10;	}	},
                        {	label:'No Data',
                            value: function(rowData,rowIdx){
                                return rowData[3]<0;					}	},                                
                    ]                    
                },
                targets:[3]
            },

        	// HSK Column
            {
                searchPanes:{
                	initCollapsed: true,
                	// preSelect: ["-1","4","5","6"], // This isn't working :/
                },
                targets:[4]
            },

        	// Type Column
            {
                searchPanes:{
                	initCollapsed: true,
                	// preSelect: ["dictionary"] this isn't working :/
                },
                targets:[5]
            },

            // Garbage Columns
            {
                targets:-2,
                data:null,
                defaultContent:'<button class="mark-garbage">X</button>',
            },

            // Known Column
            {
                targets:-1,
                data:null,
                defaultContent:'<button class="mark-known">X</button>',
            }

        ],

        scrollX: true,


    });


    // Marking words as known. I also want to be able to just delete shingles from an input text this way as well
    // Maybe this button can actually pop up with some options to choose from. 
    $('#my-table tbody').on('click', 'button.mark-known', function () {
        var word = table.row($(this).parents('tr')).data()[0];
        var user_id = $(this).parents('table').attr("user_id");
        var row = $(this).parents('tr')        
        $.ajax({
          url: '/known_word_create_ajax',
          type: 'POST',
          data: {"word":word, "user_id":user_id},
          success: function(res) {
            console.log(res)
            console.log('Load was performed.');
            row.css({"display":"none"})
          }
        });
    });



    // For marking words as garbage
    $('#my-table tbody').on('click', 'button.mark-garbage', function () {
        var word = table.row($(this).parents('tr')).data()[0];
        var user_id = $(this).parents('table').attr("user_id");
        var row = $(this).parents('tr')        
        $.ajax({
          url: '/garbage_word_create_ajax',
          type: 'POST',
          data: {"word":word, "user_id":user_id},
          success: function(res) {
            console.log(res)
            console.log('Load was performed.');
            row.css({"display":"none"})
          }
        });
    });


    // Default options for simpler tables
    var default_language = {
            search: "_INPUT_",
            searchPlaceholder: "Search...",
            lengthMenu:'<select>'+
              '<option value="10">10</option>'+
              '<option value="20">20</option>'+
              '<option value="50">50</option>'+
              '<option value="100">100</option>'+
              '</select>'   
        }

    // Simpler tables
	$('#my-input-texts').DataTable({
		language: default_language,
		scrollX: true,
        order: [[2,'desc']],
	})


    $('#my-known-words').DataTable({
        language: default_language,
        scrollX: true,
        order: [[1,'desc']],
    })

     $('#my-garbage-words').DataTable({
        language: default_language,
        scrollX: true,
        order: [[1,'desc']],
    })   

    $('#users-table').DataTable({
        language: default_language,
        scrollX: true,
        order: [[2,'asc'],[1,'desc']], //Show confirmed but not approved at the top of the table
    })

});