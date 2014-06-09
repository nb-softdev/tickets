$(document).ready(function() {
	$('.lnkbtn').click (function() {
	  $("#spinner").show();
	});

	$('.selectFieldAjax').change (function() {
	  $("#spinner").show();
	});

	$('#check_all').click (function() {
	  $(this).closest('table').find('input[type=checkbox]').prop('checked', this.checked);
	});

	$(".table input:checkbox").click (function() {
		var checked = $(".table input:checked").length > 0;
		$(".dropdown-menu").hide();
		if (checked) {
			$(".dropdown-menu").show();
		}	
	});	

	$('#destroy_all').click (function() {
		var checked = $(".table input:checked").length > 0;
	  if (checked) {
	  	var msg = "Are you sure want to remove selected record(s)?";
	    if(confirm(msg)){
	    	$('#tag_or_destroy').val("destroy_all");
	     $("#index_form").submit();
	    } else {
	    	return false;
	    }
	  }else {
	  	alert('Please select atleast one record');
	  	return false;
	  }
	});
	
$('#apply_labels').click (function() {
	var checked = $(".dropdown-menu input:checked").length > 0;
  if (checked) {
  	var msg = "Are you sure want to apply?";
    if(confirm(msg)){
    	$('#tag_or_destroy').val("apply_labels");
    	$("#index_form").trigger('submit.rails');
    	//$(this).parents('form:first').submit();
      return true;
    } else {
    	return false;
    }
  }else {
  	alert('Please select atleast one label');
  	return false;
  }	    
});	

	$('#search_button').click(function(){
    $('.form-horizontal').trigger("reset");
    $('#search_form').show();
  });
  
  $('#sidebar_all_lnk').click(function(){
		 $( "#sidebar_all" ).slideToggle( "slow", function() {});
  });

  $('#sidebar_label_lnk').click(function(){
		 $( "#sidebar_label" ).slideToggle( "slow", function() {});    
  });
  
  $('#sidebar_status_lnk').click(function(){
		 $( "#sidebar_status" ).slideToggle( "slow", function() {});    
  });
  
  $('#sidebar_priority_lnk').click(function(){
		 $( "#sidebar_priority" ).slideToggle( "slow", function() {});    
  });
  
  $('#sidebar_type_lnk').click(function(){
		 $( "#sidebar_type" ).slideToggle( "slow", function() {});    
  });  


});
$(function() {
  $('.pagination a').attr('data-remote', 'true')
});

function assign_staff(ticket_id, staff_id) {
  $.get( "/assign/staff/"+ticket_id+"?staff_id="+staff_id );
}

