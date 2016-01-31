$(document).ready(function(){
  $(".edit-button").click(function(event){
    event.preventDefault();
    if ($(".edit-button").hasClass("disabled")){
      return false
    }
    else {
      url = $(this).attr("href");
      $.ajax({
        method: "GET",
        url: url
      }).done(function(response){
        $("#start").parent().prepend(response);
        $(".edit-button").addClass('disabled');
      });
    };
  });
})

function testcheck()
{
    if (!jQuery("#checkbox").is(":checked")) {
        alert("You must select at least one user");
        return false;
    }
    return true;
}
