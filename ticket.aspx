<%@ Page Language="vb"  Trace="false"  AutoEventWireup="false" CodeBehind="TicketSupport.aspx.vb"  EnableViewState="true" Inherits="pts_net.TicketSupport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title>TicketSupport</title>
	<link href="../<%= ConfigurationManager.AppSettings("styles")%>/<% =IIf(Direction = "rtl", StyleName & "-rtl", StyleName ) %>.css" type="text/css"  rel="stylesheet" id="ptsStylesheet" />
    <script type="text/javascript" src="../_js/jquery/json.js"></script>

	<script type="text/javascript" src="../_js/<%= ConfigurationManager.AppSettings("clientjs")%>"></script>
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1" />
    <meta name="CODE_LANGUAGE" content="Visual Basic .NET 7.1" />
    <meta name="vs_defaultClientScript" content="JavaScript" />
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5" />


    <asp:Literal ID="insertJs" runat="server"></asp:Literal>
    <script src="../_js/jquery/ajaxfileupload.js" type="text/javascript"></script>



<style>
   
    
    
.head { font-weight:bold ; border-right:0px ; }
.topbot { border-left:0px ; border-right:0px}
.right { text-align:right}   
.container {   position:relative;width:980px;border:0px;margin: 0px auto;z-index:0; margin-bottom:10px; }
.expired{color:red}
.left, .right, .mid {position: relative;bottom: 0;}
.left {left:0px; width:20px;  float:left;clear:both;}  
.mid {left:30px; width:940px; float:left; z-index:0; }
.right {right:0px; width:20px; float:right;}     
input {width: 125px;}
.spacer { line-height:22px; height:22px }
.expired{color:red}


* 									{ margin: 0; padding: 0; }
ul									{ list-style: none; font-size:small }
/* LEVEL ONE*/
ul.dropdown                         { position: relative;  z-index: 1000; }
ul.dropdown li                      {  float: left; background: #414747; font-size:10px ;	BORDER: #2e2e2e 1px solid; color:#fff;  margin-left:5px}
ul.dropdown a:hover		            { color:#fff;   font-size:10px}
ul.dropdown li a                    { display: block; padding: 4px 8px; border-right: 1px solid #333;color: #fff; }
ul.dropdown li:last-child a         { border-right: none; } /* Doesn't work in IE */
ul.dropdown li.hover,
ul.dropdown li:hover                { background: #414747; color: #fff; position: relative; }
ul.dropdown li.hover a              { color: #fff; }
/* LEVEL TWO*/
ul.dropdown ul 						{  visibility: hidden; position: absolute; top: 100%; left: 0;  font-size:10px ; width:150px }
ul.dropdown ul li 					{ font-weight: normal;   float: none; font-size:10PX ;filter:alpha(opacity=86) ; font-size:10PX ; 	opacity:0.86;  }
ul.dropdown ul li a:hover				{  COLOR: #0083c5; 	BACKGROUND-COLOR: #414747;  } 
/* IE 6 & 7 Needs Inline Block */
/* LEVEL THREE*
ul.dropdown ul li a					{ border-right: none; width: 100%; display: inline-block; filter:alpha(opacity=86) ; font-size:10PX ; 	opacity:0.86;  COLOR: #FFFFFF; BORDER: #2e2e2e 1px solid;	BACKGROUND-COLOR: #414747; } 
*/
ul.dropdown ul ul 					{ left: 100%; z-index: 1000; }
ul.dropdown li:hover > ul 			{ visibility: visible; }

</style>




    <script type="text/javascript" >
       var ImagePath = "<%= imagepathname %>"
       var FilterObjects = {}; // gets filters
       var SaveTicketObject = {} // save ticket stringify json
       var TicketID =  "<%= TicketID %>" ;
       var DealerID = "<%= DealerID %>" ;
       var brand = '<% = brand.ToLower %>';
       var uploadlocation = '<%= uploadticketlocation %>';
       var updatedby =  '<%= updatedby %>';
       var newreply = "_1" // use a temp id to add new comments
       var lastupdated =   '<% = lastupdated  %>';
       var noresults = '<% = NoResults  %>';
       var coutryid =  "<%= coutryid %>" ;
       var languagecode = '<% = languagecode %>';
       var nowdatestring = '<% = lastupdateddateformat %>';
       var saveissue = ' <% = resx.GetString("buttons.SaveIssue") %>'
       var saveaction =' <% = resx.GetString("buttons.SaveAction") %>'
       var saveticket =' <% = resx.GetString("buttons.SaveTicket") %>'
       var deleteticket =  ' <% = resx.GetString("buttons.DeleteTicket") %>'

       var globalpopupid = ''

   
   var JsonCategory = <%= JsonCategory() %>
   var JsonContacts = <%= JsonContacts() %>
   var JsonPriority = <%= JsonPriority() %>
   var JsonProduct = <%= JsonProduct() %>
   var JsonProduct = <%= JsonProduct() %>
   var JsonMethod = <%= JsonMethod() %>   
   var JsonIssueType =<%= JsonIssueType() %> 


 
 
        $(document).ready(function () {
            GetFilters()
            if (noresults == "False" ) {
                  GetTicket()
            }

            // Slide Open Tickets
            $('.left').click(function () {
                var img = $(this).find('img');
				var src =  $(this).find('img')[0].src;
                var idticketno = img.attr('id');  // old one  var src = img.attr('src');

               $(".contract" + idticketno).toggle();
               $(".expand" + idticketno).toggle();
				
                if (src == ImagePath + 'plus.png') {
                    img.attr('src', ImagePath + 'minus.png');
                    return false;
                }
                if (src == ImagePath + 'minus.png') {
                    img.attr('src', ImagePath + 'plus.png');
                    return false;
                }
            });



             $(document).on("click" ,".right , .openclose" , function(e){
 

                var img = $(this).find('img');
                var src = img.attr('src');
                var tid = img.attr('tid')

  
          
                if (src == ImagePath + 'checkboxopen.png' || src ==  '../_images/checkboxopen.png') {
                    img.attr('src', ImagePath + 'checkboxclose.png');
                       // disable all these ticket boxes

                       // we only want to hide all the textboxes if the Big Toggle on right is clicked
                      if  ($(event.target).attr('class') != 'opencloseaction' ) {
                          $('.expand' + tid ).find('input, textarea , select, a').attr('disabled','disabled');
                      }

                    return false;

                }
                if (src == ImagePath + 'checkboxclose.png' || src ==  '../_images/checkboxclose.png') {
                    img.attr('src', ImagePath + 'checkboxopen.png');

                      // we only want to hide all the textboxes if the Big Toggle on right is clicked
                      if  ($(event.target).attr('class') != 'opencloseaction' ) {
                          $('.expand' + tid ).find('input, textarea , select, a').attr('disabled',false);
                      }
                  
                  
                  
                  
                    return false;
                }
            });




        // Attachments
         $('.browse').live('change', function (e) {
              var ticket_id = this.id.replace("browse","");  // get ticketid of onchange item
              var savelocation =  encodeURIComponent( uploadlocation + "\\" + DealerID +   "\\tickets\\"  +  ticket_id )
              var filen = this.value.replace(/^.*[\\\/]/, '')
                 $("#loading").ajaxStart(function () {
                     $(this).show();    })    
                    .ajaxComplete(function () {        
                     $(this).hide();    });
                    
                     $.ajaxFileUpload    
                  (         
                                {
                                    url:  folderName + '/handlers/uploadfile.ashx',            
                                         secureuri: false,            
                                         fileElementId: this.id,           
                                         dataType: 'json',
                                         data: { DealerID: DealerID , SaveLocation: savelocation },             
                                         success: function (data, status) {                
                                                 if (typeof (data.error) != 'undefined') {
                                                     if (data.error != '') { alert('uploaddate-' + data.error);              
                                                             } else {  $("#attachment" + ticket_id).append("<option value=\""  + filen +  "\">"+  filen +"</option>") }               
                                                     }            
                                            },            
                                            error: function (data, status, e) {    
                                                          alert('upload:' + e);  }        
                                         })
                            return false;
           });// end browse . click


// DELETE TICKET
       $(document).on("click" ,".deltick .buttons" , function(e){
            var id = $(this).attr('tid'); //  checks for empty drop down, will not allowed to be saved

var r = confirm("Delete:" + id);
if (r == true) {
    txt = "Ticket Deleting";



            $.ajax({
                    type: 'POST', 
                    contentType: "application/json; charset=utf-8",
                    url: "<%= WebService %>/TicketDelete",
                    data: "{TicketID:'" + id + "',updatedby:'" + updatedby + "'}",
                    dataType: "json",
                    cache: false,
                    success: function (data) { 
                                  if (data.d == true) {
                                        location.reload()     
                                   } else {
                                         alert("fail to delete , please contact support")
                                      location.reload()   
                                   }

                           },
                    error: function (XMLHttpRequest, textStatus, errorThrown) { alert("ticketdelete:" + textStatus + "-"+ errorThrown); }

             
                        });

}else {


   location.reload()   
}
                  
       });
   

// BIG SAVE BUTTON PER TICKET
 $(document).on("click" ,".savebutton .buttons" , function(e){    
        e.preventDefault(); 
                var id = $(this).attr('tid'); //  checks for empty drop down, will not allowed to be saved
                  if  (checksaveconditions(id) == false ) {
                return false
                }
                SaveTicketObject.contactperson =   $('#contactp_'+ id).val() 
                SaveTicketObject.telephone =   $('#Tel_'+ id).val()
                SaveTicketObject.duedate =   $('#DueDate_'+ id).val()
                SaveTicketObject.assignto=  $('#ticketassignedto_'+ id).find('option:selected').text()  

               // SaveTicketObject.orgduedate =  $('#DueDate_'+ id).attr('org')

                       var today = new Date();
                       var duedate= new Date($('#DueDate_'+ id).val())
                       var orgdate = new Date($('#DueDate_'+ id).attr('org')); // we have this here as the origonal date but acutally i dont think we need it
       
                                        // check if expired
                                      if( duedate < today) {
                                             $('#DueDate_'+ id).css("color","red")
                                             $('#duetext_'+ id).css("color","red")
                                             $('#expireheader_'+ id).css("color","red")
                                           
                                       }else{
                                         $('#DueDate_'+ id).css("color","black")
                                         $('#duetext_'+ id).css("color","black")
                                         $('#expireheader_'+ id).css("color","black")

                                       }

                var email = $('#email_'+ id).val()  ;
                   $.ajax({
                    type: 'POST', 
                    contentType: "application/json; charset=utf-8",
                    url: "<%= WebService %>/TicketSave",
                    data: "{DealerID:'" + DealerID + "',Ticket:'" + TicketID + "',updatedby:'" + updatedby + "',email:'" + email + "',lang:'" + languagecode + "',SaveTicketObject:" + JSON.stringify(SaveTicketObject) + "}",
                    dataType: "json",
                    cache: false,
                    success: function (data) {
                                                document.getElementById('lastchangedate_' + TicketID).innerHTML =  nowdatestring
                                                document.getElementById('lastchangeby_' + TicketID).innerHTML =  updatedby
                                                $('.tp_'+ id).html(SaveTicketObject.prioritytext)
                                                $('.tp_'+ id).next().html(SaveTicketObject.categorytext + ' / ' + SaveTicketObject.issuetypetext + " / " + SaveTicketObject.methodtext + ' / ' +SaveTicketObject.producttext)
                                         
                                                //0 - status of save
                                                //1 is expired or not but we can do with js instead

                                                alert(data.d[0])


                                                 // }
                    },
      
                        error: function (XMLHttpRequest, textStatus, errorThrown) { alert("TicketSave"+ textStatus + "-" +errorThrown); }
                        });

     $("#newtick").show()
     $("#deltick").hide()
    $("#newticklable").hide()

    $('#save_'+ id).hide()
   

    });

 

    // Action and Issue Saves
     $(document).on("click" ,".boxes .buttons" , function(e){


            e.preventDefault(); 
             
            var issuetext =''
            var actiontext  =''
            var tid =$(this).attr('tid')

            // validate the ticket selection before continue!
                if  (checksaveconditions(tid) == false ) {
                return false
                }


            var id = $(this).attr('id');        // saveaction_3  saveaction_3_1    the last part is for newadded Rely's that are not yet saved into database. once saved, we overwrite the id' of these
            var cropid = id.replace('save','') //  action_3  action_3_1
            var n=id.indexOf("_");
            var getidvalue = id.substring(n,id.length)  //  _3   _3_1
            var boxtype = $(this).attr('box');    //box=\"issue\"  id=\"" + ticketid + newreply  +"\"
            var actiontime =   $('#actiontime' + getidvalue).val();
               var isopenorclosed = 'open' // is checkbox open or closed?
               var img = $('#actionopen'+ getidvalue).attr('src')
                  if (img == ImagePath + 'checkboxclose.png') {
                   isopenorclosed ='close'
                }

             if ( boxtype == 'issue') {issuetext = encodeURIComponent($('#' + cropid).val())
               issuetext = issuetext.replace(/\'/g, "%27");
             }
             if ( boxtype == 'action'){actiontext = encodeURIComponent($('#' + cropid).val())
                actiontext = actiontext.replace(/\'/g, "%27");
             }

               $.ajax({
                 type: 'POST', 
                contentType: "application/json; charset=utf-8",
                url: "<%= WebService %>/TicketSaveData",
                data: "{TicketDataID:'" + id + "',actiontext:'" + actiontext  + "',issuetext:'" + issuetext  + "' ,updatedby:'" + updatedby +  "',ButtonClicked:'" + boxtype  + "',timespent:'" + actiontime  + "',statusaction:'" + isopenorclosed  + "',lang:'" + languagecode  + "'}",
                dataType: "json",
                cache: false,
                success: function (data) {

                    if (data.d.ticketdataid == "0") {
                            // this is for exsisting Issues/Actions
                             document.getElementById('time_' + data.d.ticketid).innerHTML =  data.d.totaltime

                             // gets below lastupdated and updateby via the codebehind onload
                                 document.getElementById('lastchangedate_' + data.d.ticketid).innerHTML =  nowdatestring
                                 document.getElementById('lastchangeby_' + data.d.ticketid).innerHTML =  updatedby

                           //  alert(data.d.ticketupdate)

                    } else {
                           //this is for brand new issue actions
                          // we now change the ticketdataid to a new value from database return

                          //replace id for savebuttons
                            var thisissue = document.getElementById('saveissue' + getidvalue );
                                 thisissue.id ="saveissue_" + data.d.ticketdataid
                            var thisaction = document.getElementById('saveaction' + getidvalue);
                                 thisaction.id ="saveaction_" + data.d.ticketdataid

                             //replace the id for the Textbox       
                             var changeissueid = document.getElementById('issue' + getidvalue);
                                 changeissueid.id ="issue_" + data.d.ticketdataid
                             var changeactionid = document.getElementById('action' + getidvalue);
                                  changeactionid.id ="action_" + data.d.ticketdataid

                               //replace the id for time
                                  var changetimeid = document.getElementById('actiontime' + getidvalue);
                                  changetimeid.id ="actiontime_" + data.d.ticketdataid
                            
                               // replace id for closed action   
                            var imgid = document.getElementById('actionopen'+ getidvalue);
                                imgid.id = "actionopen_" + data.d.ticketdataid
               


               var isopenorclosed = 'open' // is checkbox open or closed?
               var img = $('#actionopen'+ getidvalue).attr('src')
                  if (img == ImagePath + 'checkboxclose.png') {
                   isopenorclosed ='close'
                }
                              document.getElementById('time_' + data.d.ticketid).innerHTML =  data.d.totaltime 
                             alert("Added New Reply")
                    }

                },
                error: function (XMLHttpRequest, textStatus, errorThrown) { alert("action-issuesave: "+ textStatus + "-" +errorThrown); }
            });

    });

    return false
        }); // end doc onload     http://stackoverflow.com/questions/11044694/how-to-detect-ajax-call-failure-due-to-network-disconnected 




  // TOGGLE OPEN CLOSE TICKET
  $(document).on("click" ,".toggle" , function(e){
    var ticketid  = $(this).attr('tid')

    // check if ticket is valid before closeing!
    //var toggleopencloseicon = document.getElementById('statusimg_' + ticketid);

                var src =  $(this).attr('src');

                if (src.indexOf("checkboxopen") >= 0) {
                        if  (checksaveconditions(ticketid) == false ) {
                         return false
                     }

                    }   

               

     $.ajax({
                type: 'POST', 
                contentType: "application/json; charset=utf-8",
                url: "<%= WebService %>/UpdateTicketStatus",
                data: "{TicketID:'" + ticketid + "',UpdatedBy:'" + updatedby +  "'}",
                dataType: "json",
                cache: false,
                success: function (data) {
                                            if (data.d == false) {
                                                 var t = document.getElementById('statusimg_' + ticketid);
                                                      t.title ='Ticket is Open'
                                                  
                                             
                                                        $("input[tid='" +  ticketid  +"']" ).show()
                                                         $("div[tid='" +  ticketid  +"']" ).show()
                                                         $("a[tid='" +  ticketid  +"']" ).show()

                                                           var today = new Date();
                                                           var duedate= new Date($('#DueDate_'+ ticketid).val())
         
                                                                                  if( duedate < today) {
                                                                                         $('#DueDate_'+ ticketid).css("color","red")
                                                                                         $('#duetext_'+ ticketid).css("color","red")
                                                                                         $('#expireheader_'+ ticketid).css("color","red")
                                                                                   }
                                                  } else {
                                                    var t = document.getElementById('statusimg_' + ticketid);
                                                          t.title ='Ticket is Closed'
                                                        $("input[tid='" +  ticketid  +"']" ).hide()
                                                        $("div[tid='" +  ticketid  +"']" ).hide()
                                                        $("a[tid='" +  ticketid  +"']" ).hide()
                                                                     // close tickets are always black
                                                                     $('#DueDate_'+ ticketid).css("color","black")
                                                                     $('#duetext_'+ ticketid).css("color","black")
                                                                     $('#expireheader_'+ ticketid).css("color","black")
                                            }
                                         },
                             error: function (XMLHttpRequest, textStatus, errorThrown) { alert("UpdateTicketStatus" + textStatus + errorThrown); }
                 });

    });  // END TOGGLE OPEN CLOSE TICKET


  // TOGGLE OPEN CLOSE REPLY ACTION
  $(document).on("click" ,".opencloseaction" , function(e){

      
  //actionopne_3_1
  //actionopen_4    we want to check if this is a saved action!  so we ignore new entry with actionopen_3_1
    var action = $(this).attr('id')
    var ticketids = $(this).attr('tid')
    var n=action.split("_"); 

    if(n[2] == undefined){
        var actionid = n[1]
            $.ajax({
                    type: 'POST', 
                    contentType: "application/json; charset=utf-8",
                    url: "<%= WebService %>/UpdateTicketActionStatus",
                    data: "{ActionID:'" + actionid + "',UpdatedBy:'" + updatedby +  "',TicketID:'" + ticketids +  "'}",
                    dataType: "json",
                    cache: false,
                    success: function (data) {
                                                if (data.d == false) {

                                         
                                                       var t = document.getElementById(action);
                                                        $("#saveaction_" + actionid).show()
                                                        $("#saveissue_" + actionid).show()
                                                        $("#action_"   + actionid).removeAttr("disabled"); // text box
                                                        $("#issue_"   + actionid).removeAttr("disabled"); // text box
                                                        $("#tdid"   + actionid).removeAttr("disabled"); // text box

                                                       $("#poppyissue_" +  actionid).removeAttr("disabled")  //bring poplight back to life
                                                       $("#poppyaction_" +  actionid).removeAttr("disabled")  //bring poplight back to life

                                             
                                                        t.title ='action item is now open'


                                                        } else {

                                                   
                                                              var t = document.getElementById(action);
                                                          
                                                           $("#saveaction_" + actionid).hide() // hide
                                                           $("#saveissue_" + actionid).hide() // hide
                                                           $("#action_" +  actionid).attr("disabled", "disabled");   // text box
                                                           $("#issue_" +  actionid).attr("disabled", "disabled");  // text box

                                                              $("#poppyissue_" +  actionid).attr("disabled", "disabled");  //kill poplight href
                                                              $("#poppyaction_" +  actionid).attr("disabled", "disabled");  //kill  poplight href
                                                   
                                                       
                                                               $("#tdid" +  actionid).attr("disabled", "disabled");  // text box
                                                        

                                                         var anchoraction = $(this).attr('tdid')

                                                          
                                                           t.title ='action item is now closed'
                                                    
                                                  }
                                                },
      
                                    error: function (XMLHttpRequest, textStatus, errorThrown) { alert("UpdateTicketActionStatus:" + textStatus +"-" + errorThrown); }
                        });
     }
     else {alert("not updated on D.B. you will need to click SaveAction button")}
    });



// IF newticketid = 0 then we insert a new ticket
function LoadTicketData(newticketid) {


        TicketID =  newticketid
        if (TicketID == 0) {
                    GetTicket();
                         return false; 
                     }
           var img =   $('.left #' + newticketid)
           var src = img.attr('src');
		   var imagep = ImagePath + 'plus.png'
                if ( src.substr(src.length - 8) == imagep.substr(imagep.length - 8)) { // only want to load data is + is clicked
					  GetTicket();
                    return false;
					
                }
        }



        function AddReply(ticketid) {

                // For some sick twisted reason i cant call this calling function, so for now , i just past the below code .
                SaveTicketObject.category =  $('#ticketcategory_'+ ticketid).find('option:selected').val(); 
                SaveTicketObject.method =   $('#ticketmethod_'+ ticketid).find('option:selected').val();
                SaveTicketObject.priority =  $('#ticketpriority_'+ ticketid).find('option:selected').val(); 
                SaveTicketObject.product =   $('#ticketproduct_'+ ticketid).find('option:selected').val();
                SaveTicketObject.issuetype =   $('#ticketissuetype_'+ ticketid).find('option:selected').val();
                if (SaveTicketObject.category == 0) {  alert("please select a category "); return false   }
                if (SaveTicketObject.method == 0) {  alert("please select a method "); return false   }
                if (SaveTicketObject.priority == 0) {  alert("please select a priority "); return false   }
                if (SaveTicketObject.product == 0) {  alert("please select a product "); return false   }
                if (SaveTicketObject.issuetype == 0) {  alert("please select a issuetype "); return false   }
                if (SaveTicketObject.category == 0) {  alert("please select a category "); return false   }
                // For some sick twisted reason i cant call this calling function, so for now , i just past the below code .


               // validate the ticket selection before continue!
                        // clicking on checkbox prior to save will not 
                         var html = "";
                             html += "<div class=\"boxes\" style=\"position:relative ; float:left; clear:none; width:300px; padding-bottom:15px \">"
                             html += "<div style=\"clear:both;border-right:1px solid black ;border-left:1px solid black;border-top:1px solid black; width:60px; text-align:center \"><a href=\"#?w=800\" id=\"poppyissue_" + ticketid + newreply   + "\" reply=\"reply\" rel=\"popblock\" box=\"issue\"  tdid=\"" + ticketid + newreply   + "\" class=\"poplight\"><% = resx.GetString("columnName.Reply") %></a></div>"
                                         html += "<textarea id=\"issue_" + ticketid + newreply +"\"  name=\"issue_" + ticketid  + newreply +"\" style=\"width:269px\" rows=\"5\"></textarea>"
                                         html += "<input type=\"submit\" tid=\"" + ticketid +"\" class=\"buttons\" name=\"saveissue_" + ticketid + newreply  +"\" value=\"Save Reply\" box=\"issue\"   id=\"saveissue_" + ticketid + newreply  +"\"  style=\"float:right;position:relative; right:21px \">"  
                          
                             html += "</div>"
                                
                             html += "<div  class=\"boxes\" style=\"position:relative ; float:left; clear:none; width:300px; padding-bottom:15px\">"
                             html += "<div style=\"clear:both;border-right:1px solid black ;border-left:1px solid black;border-top:1px solid black; width:60px; text-align:center \">  <a href=\"#?w=800\" reply=\"reply\"  id=\"poppyaction_" + ticketid + newreply   + "\"  rel=\"popblock\" box=\"action\" tdid=\"" + ticketid + newreply   + "\" class=\"poplight\"><% = resx.GetString("columnName.action") %> </a></div>"
                                        html += "<textarea id=\"action_" +  ticketid + newreply + "\"   name=\"action_" + ticketid + newreply + "\"  style=\"width:269px\" rows=\"5\"></textarea>"
                                        html += "<input type=\"text\" value=\"2\" name=\"actiontime_" + ticketid + newreply + "\"   id=\"actiontime_" + ticketid + newreply + "\"   style=\"width:30px\" />min"
                                        html += "<input type=\"submit\" tid=\"" + ticketid +"\"  class=\"buttons\" name=\"saveaction_" + ticketid + newreply  +"\" value=\"" + saveaction  + "\" box=\"action\"  id=\"saveaction_" + ticketid + newreply  +"\"  style=\"float:right;position:relative; right:21px \">"  
                                     html += "<div class=\"openclose\" style=\"float:right\"><img  class=\"opencloseaction\" src=\"../_images/checkboxopen.png\" title=\"this action is open\" alt=\"this action is open\" tid=\""+ ticketid + "\" id=\"actionopen_"  + ticketid + newreply  +"\"  alt=\"select\" style=\"float:right;position:relative; right:21px \"></div>"
                             html += "</div>"


                            $("#datatexts_" + ticketid).append(html);
                            var commentint = newreply.replace("_",'')
                                commentint ++ ;
                                newreply = "_" + commentint 
      
                  // add new reply we save js  newreply var as _1  ++ incriment int.
                  // we save the textareas as _1_1  ie _Ticketid_ticketdata
                  // when we click the save box, we must change the ID' of these boxes to reflect the correct id names taken from database.

                    return false;
                }

  $(document).on("keydown" ,".emailsend" , function(e){
             if (e.which == 13) {
             var tid = $(this).attr('id')
                        e.preventDefault();
                        $.ajax({
                            type: 'POST',  
                            async: false,
                            contentType: "application/json; charset=utf-8",
                            url: "<%= WebService %>/TicketEmail",
                                data: "{DealerID:'" + DealerID + "',Ticket:'" + tid + "',lang:'" + languagecode + "',email:'" + $(this).val() + "', FilterSearchList:" + JSON.stringify(FilterObjects) + "}",
                            dataType: "json",
                            cache: false,
                            success: function (data) {
                                    if (data.d == "") {
                                        alert("Error getting Ticket, no email was sent.")
                                      } else {
                                      var togg =  $('#emailticket_'  + tid ).slideToggle();
                                       alert("ticket is emailed")
                                    }

                                },            
                                      error: function (data) {    
                                                         alert("Ticket Email Failed")
                                                    }    
                            })
                return false;
                       }
        })


// TicketSearch
  $(document).on("keydown" ,".ticketsearch" , function(e){
            if (e.which == 13) {
                    e.preventDefault();
                     var tid = $(this).val()
                     var isno = isNaN(tid)
                       if  (isno == false ) {  window.location.href = "TicketSupport.aspx?SearchTicketID=" + tid  +"&DealerID=" + DealerID   } else {  alert("not a valid ticket no.")  }
             }

        })



function PoPoUT(tid) {

	dealerPopup = window.open(folderName+'/_support/TicketSupport.aspx?TicketID=' + tid   +'&DealerID=' + DealerID +'&popup=true' +'&Brand='+brand,'openticket','width=990,height=650,status,scrollbars,resizable');
	dealerPopup.focus();
	
}

function showsavebutton(saveid){

    $('#save_'+ saveid).show()
  //  $('#save_'+ saveid).attr('class', 'buttonsAlert'); cant get this to work, so i just make the save button ugly red from start! 
          
}


    function GetTicket()  {
                 var html = "<!-- COLUMNS ONE -->";
         
            $.ajax({
                type: 'POST',  
                async: false,
                contentType: "application/json; charset=utf-8",
                url: "<%= WebService %>/TicketSingleReturn",
                data: "{DealerID:'" + DealerID + "',Ticket:'" + TicketID + "',lang:'" + languagecode + "',FilterSearchList:" + JSON.stringify(FilterObjects) + "}",
                dataType: "json",
                cache: false,
                success: function (data) {
                    if (data.d == "") {
                        alert("Error getting Ticket")
                    } else {

          
                 var displaythis =''
                 if (data.d.Closed == true ) {
   
                          displaythis=';display:none'
                 }


                 if (TicketID == 0 ) { location.reload() }

                 
                          $(".expand" + TicketID).html("<div style=\"height:200px\">");

                  html += "<div  style=\"position:relative ; float:left; width:270px\">"
                          html += "<div  style=\"position:relative ; float:left;  font-weight:bolder; font-size:12px; width:135px\">"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("columnName.Ticket") %></div>"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("columnName.Created") %></div>"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("Contact.createdBy") %></div>"
                                     html += "<div class=\"spacer\" ><i><% = resx.GetString("columnName.last_updates") %></i></div>"
                                     html += "<div class=\"spacer\" ><i><% = resx.GetString("columnName.Updatedby") %></i></div>"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("Contact.TimeSpent") %></div>"
                          html +="</div>"
                          html += "<div  style=\"position:relative ; float:left; width:135px; font-size:12px; \">"
                                    html += "<div class=\"spacer\" >#" +data.d.TicketID + "</div>"
                                    html += "<div class=\"spacer\" >"+ data.d.TicketCreatedDate +"</div>"
                                    html += "<div class=\"spacer\" >"+  data.d.CreatedBy +"</div>"
                                    html += "<div class=\"spacer\"  id=\"lastchangedate_" +data.d.TicketID +"\" >"+ data.d.LastChangeDate +"</div>"
                                    html += "<div class=\"spacer\"  id=\"lastchangeby_" +data.d.TicketID +"\" >"+  data.d.LastChangedBy +"</div>"
                                    html += "<div class=\"spacer\"  id=\"time_"+data.d.TicketID +"\" >" + data.d.TotalTime + " min</div><br>"

                          html += "</div>"
                     html += "</div>"

                    html += "<div  style=\"position:relative ;float:left;  width:30px\">&nbsp</div>"

             
                     html += "<div  style=\"position:relative ; float:left;  width:270px\">"
                          html += "<div  style=\"position:relative ; float:left; font-weight:bolder;  font-size:12px; width:135px\">"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("columnName.contactperson") %></div>"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("columnName.telephone") %></div>"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("columnName.email") %></div>"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("defaultHTML.orderID") %> <img src=\"../_images/16px-Dossiers.gif\" title=\"goto order\" style=\"float:right\" onclick=OrderID("+data.d.OrderID +")  /></div>"
  
                                      if (data.d.Expired == true) {
                                      html += "<div class=\"expired\" style=\" line-height:22px; height:22px\" id=\"duetext_" +data.d.TicketID +"\"  ><% = resx.GetString("columnName.TicketDueDate") %></div>"  
                                               } else {
                                         html += "<div class=\"spacer\" > <% = resx.GetString("columnName.TicketDueDate") %> </div>"
                                     
                                    }


                          html +="</div>"
                          html += "<div  style=\"position:relative ; float:left;   width:135px\">"
                                    html += "<div class=\"spacer\" > &nbsp;<input  onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"    type=\"text\" value=\"" + data.d.ContactPersonExternally + "\" id=\"contactp_" +data.d.TicketID+ "\"  name=\"contactp_" +data.d.TicketID+ "\" /></div>"
                                    html += "<div class=\"spacer\" > &nbsp;<input  onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"    type=\"text\" value=\"" + data.d.Telephone               + "\" id=\"Tel_" +data.d.TicketID+ "\"       name=\"Tel_" +data.d.TicketID+ "\" /></div>"
                                    html += "<div class=\"spacer\" > &nbsp;<input  onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"    type=\"text\" value=\"" + data.d.Email               + "\" id=\"email_" +data.d.TicketID+ "\"       name=\"email_" +data.d.TicketID+ "\" /></div>"
                                    html += "<div class=\"spacer\" > &nbsp;<input  onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"    type=\"text\" value=\"" + data.d.OrderID                 + "\" id=\"OrderID_" +data.d.TicketID + "\"  name=\"OrderID_" +data.d.TicketID + "\" /></div>"
                                   
                                   
                                     if (data.d.Expired == true) {
                                         html += "<div class=\"spacer\" > &nbsp;<input  onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"   style=\"color:red\" type=\"text\" value=\"" + data.d.TicketDueDate           + "\" id=\"DueDate_" +data.d.TicketID + "\"  name=\"DueDate_" +data.d.TicketID + "\" org=\"" + data.d.TicketDueDate + "\" /></div>"
                                
                                    } else {
                                             html += "<div class=\"spacer\" > &nbsp;<input type=\"text\" onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"  value=\"" + data.d.TicketDueDate           + "\" id=\"DueDate_" +data.d.TicketID + "\"  name=\"DueDate_" +data.d.TicketID + "\" org=\"" + data.d.TicketDueDate + "\" /></div>"
                       
                                    }
                                   
                         html += "</div>"
                     html += "</div>"

                     html += "<div  style=\"position:relative ;float:left;  width:30px\">&nbsp</div>"

                    html += "<!-- COLUMNS three -->";
                     html += "<div  style=\"position:relative ;  float:left; width:340px\">"
                          html += "<div  style=\"position:relative ; float:left;  font-weight:bolder; font-size:12px; width:100px\">"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("columnName.IssueType") %></div>"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("columnName.Category") %></div>"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("columnName.Product") %></div>"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("columnName.Priority") %></div>"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("columnName.Method") %></div>"
                                     html += "<div class=\"spacer\" ><% = resx.GetString("columnName.Assigned") %></div>"
                          html +="</div>"
                          html += "<div  style=\"position:relative ; float:left; width:240px\">"
                                  html +=  "<div class=\"spacer\"><select onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"   id=\"ticketissuetype_" + data.d.TicketID + "\" name=\"ticketissuetype_" + data.d.TicketID + "\">" + getLists('JsonIssueType' ,data.d.TicketIssueType) +"</select></div>"
                                  html +=  "<div class=\"spacer\"><select onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"   id=\"ticketcategory_" + data.d.TicketID + "\" name=\"ticketcategory_" + data.d.TicketID + "\">" + getLists('JsonCategory' ,data.d.TicketCategory) +"</select></div>"
                                  html +=  "<div class=\"spacer\"><select onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"   id=\"ticketproduct_" + data.d.TicketID + "\" name=\"ticketproduct_" + data.d.TicketID + "\">" + getLists('JsonProduct' ,data.d.TicketProduct) +"</select></div>"
                                  html +=  "<div class=\"spacer\"><select onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"   id=\"ticketpriority_" + data.d.TicketID + "\" name=\"ticketpriority_" + data.d.TicketID + "\">" + getLists('JsonPriority' ,data.d.TicketPriority) +"</select></div>"
                                  html +=  "<div class=\"spacer\"><select onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"   id=\"ticketmethod_" + data.d.TicketID + "\" name=\"ticketmethod_" + data.d.TicketID + "\">" + getLists('JsonMethod' ,data.d.TicketMethod) +"</select></div>"
                            	  html +=  "<div class=\"spacer\"><select onchange=\"javascript:showsavebutton('" + data.d.TicketID + "')\"   id=\"ticketassignedto_" + data.d.TicketID + "\" name=\"ticketassignedto_" + data.d.TicketID + "\">" + getLists('JsonContacts' ,data.d.ContactPersonInternally) +"</select></div>"
                                  
                   
                          html += "</div>"
                     html += "</div>"


                    // BUTTONS
                              html += "<div  style=\"position:relative ; float:right; right:65px; font-weight:bolder; font-size:12px; width:280px; z-index:2; background-color:transparent\">"
                                
                                      html += "<a href=\"javascript:PoPoUT('" + data.d.TicketID + "')\" > <img src=\"../_images/wp-popup.gif\" title=\"pop out\" style=\"padding:5px\"></a>"
                                     html += "<a href=\"javascript:CreateOutlookEvent('" + data.d.TicketID + "')\" ><img  alt=\"Audit Trail\" title=\"Add to OutLook\"  src=\"../_images/add-to-outlook.gif\" style=\"padding:5px\"></a>"
                                   
                                    if (data.d.GuidEmail !="" ) {
                                              html += "<a href=\"javascript:eMailOpen('" + data.d.GuidEmail + "')\" ><img  alt=\"Email\" title=\"Open Attached Email\"  src=\"../_images/open-attach.gif\"  style=\"padding:5px\"></a>"
                                     }

                                      html += "<a href=\"javascript:ShowEamilPoP('" + data.d.TicketID + "')\" > <img src=\"../_images/forward-email.gif\" title=\"Email Ticket to\" style=\"padding:5px\"></a>"
                                      html += "<img src=\"../_images/auditTrail.gif\" alt=\"Audit Trail\" title=\"Audit Trail\" onclick=\"auditTrail(" + data.d.TicketID + ")\" style=\"padding:5px ; width:25px; height:25px\">"
                                      html += "<a href=\"javascript:ShowDealerGroup('" + data.d.TicketID + "')\" > <img   alt=\"Show Group\" title=\"Show Group\"  src=\"../_images/dealer-group.gif\" style=\"padding:5px; height:30px; width:30px\"></a>"
                                     
                             
                              html += "</div>"
                      // for email insert  
                      html += "<div id=\"emailticket_" + data.d.TicketID + "\"   style=\"position:relative ; display:none ;float:right; top:30px; z-index:1000; right:-70px; font-weight:bolder; font-size:12px; width:175px;  height:38px ; border: 1px solid black; background-color:white\">"
                      html += "<center>enter email below<br>"
                      html += "<input type=\"text\" class=\"emailsend\"   id=\"" + data.d.TicketID +"\" name=\"" + data.d.TicketID + "\"  style=\"width:145px\" /></center>"
                      html += "</div>"

                      // for group insert 
                      html += "<div id=\"group_" + data.d.TicketID + "\"   style=\"position:absolute ; display:none ;float:right; top:30px; z-index:1000; right:10px; font-weight:bolder; font-size:12px ; border: 1px solid black; background-color:grey\">"
                      html += "</div>"



           // TICKET DATA
           //  TicketDateCreate  TicketDateUpdated
           html += "<div  id=\"datatexts_" + data.d.TicketID+ "\" style=\"position:relative ; float:left; width:600px; \">"

            var countreply  = 0
            var hidedata = ";display:none"
            var disabletext = "DISABLED"


                        $(data.d.TicketData.TicketDataList).each(function(index,item){
                       
                       
            
                        if (data.d.TicketData.TicketDataList[index].TicketDataClosed == false ) { hidedata = ";display:block" ;  disabletext = "" }else { hidedata = ";display:none" ; disabletext = "DISABLED" }
             

                             html += "<div class=\"boxes\"  style=\"position:relative ; float:left; clear:none; width:300px; padding-bottom:15px \">"

                               if (countreply > 0) {  
                                            html += "<div style=\"float:right ; font-size:11px; position:relative;right:30px; top:2px\" >By : " +  data.d.TicketData.TicketDataList[index].TicketUpdatedBy  + "</div><div style=\"border-right:1px solid black ;border-left:1px solid black;border-top:1px solid black; width:60px; text-align:center \"> <a href=\"#?w=800\" rel=\"popblock\" " + disabletext + "  id=\"poppyissue_" + data.d.TicketData.TicketDataList[index].TicketDataID   + "\"  box=\"issue\" tdid=\"" + data.d.TicketData.TicketDataList[index].TicketDataID  + "\" class=\"poplight\"><% = resx.GetString("columnName.Reply") %> </a></div>"
                                     }else{ html += "<div style=\"float:right ; font-size:11px; position:relative;right:30px; top:2px\" >By : " +  data.d.TicketData.TicketDataList[index].TicketUpdatedBy  + "</div><div style=\"border-right:1px solid black ;border-left:1px solid black;border-top:1px solid black; width:60px; text-align:center \"> <a href=\"#?w=800\" rel=\"popblock\"  " + disabletext + "   id=\"poppyissue_" + data.d.TicketData.TicketDataList[index].TicketDataID   + "\" box=\"issue\" tdid=\"" + data.d.TicketData.TicketDataList[index].TicketDataID  + "\" class=\"poplight\"><% = resx.GetString("columnName.Issue") %> </a></div>"  
                                   }

                                            html += "<textarea  " + disabletext + "  tid=\"" + data.d.TicketID +"\"  id=\"issue_" +  data.d.TicketData.TicketDataList[index].TicketDataID +"\" style=\"width:269px\" rows=\"5\">" + data.d.TicketData.TicketDataList[index].TicketIssueText + "</textarea>"  
                     
                               if (countreply > 0) { 
                                            html += "<input type=\"submit\" tid=\"" + data.d.TicketID +"\"  class=\"buttons\" name=\"saveissue_" + data.d.TicketData.TicketDataList[index].TicketDataID  +"\" value=\"Save Reply\" box=\"issue\"  id=\"saveissue_" + data.d.TicketData.TicketDataList[index].TicketDataID  +"\"  style=\"float:right;position:relative; right:21px " + hidedata +" \">"           
                                 }else{ 
                                            html += "<input type=\"submit\" tid=\"" + data.d.TicketID +"\"  class=\"buttons\" name=\"saveissue_" + data.d.TicketData.TicketDataList[index].TicketDataID  +"\" value=\"" + saveissue  + "\" box=\"issue\"  id=\"saveissue_" + data.d.TicketData.TicketDataList[index].TicketDataID  +"\"  style=\"float:right;position:relative; right:21px " + hidedata +" \">"             
                                  }
                                               
                             html += "</div>"
                                
                                // second box

                             html += "<div class=\"boxes\"  style=\"position:relative ; float:left; clear:none; width:300px; padding-bottom:15px\">"
                             html += "<div style=\"float:right ; font-size:11px; position:relative;right:30px; top:2px\" >Updated: " +  data.d.TicketData.TicketDataList[index].TicketDateUpdated  + "</div><div style=\"border-right:1px solid black ;border-left:1px solid black;border-top:1px solid black; width:60px; text-align:center \"> <a href=\"#?w=800\" id=\"poppyaction_" + data.d.TicketData.TicketDataList[index].TicketDataID  + "\" rel=\"popblock\" " + disabletext + "  box=\"action\" tdid=\"" + data.d.TicketData.TicketDataList[index].TicketDataID  + "\" class=\"poplight\"> <% = resx.GetString("columnName.action") %>  </a></div>"
                             html += "<textarea  " + disabletext + "   tid=\"" + data.d.TicketID +"\"   id=\"action_" +  data.d.TicketData.TicketDataList[index].TicketDataID +"\" style=\"width:269px\" rows=\"5\">"+ data.d.TicketData.TicketDataList[index].TicketActionText +"</textarea><br>"
                                       
                              ticketdataisclose = true
                               if (data.d.TicketData.TicketDataList[index].TicketDataClosed == false ) {
                                   html += "<div class=\"openclose\" tid=\"" + data.d.TicketID +"\"   style=\"float:right;position:relative;right:30px;" + displaythis + "\"><img src=\"../_images/checkboxopen.png\" tid=\"" + data.d.TicketID +"\"   class=\"opencloseaction\"  title=\"this action is open\" alt=\"this action is open\" id=\"actionopen_" + data.d.TicketData.TicketDataList[index].TicketDataID  +"\"  alt=\"select\" ></div>"
                                }else {
                                        html += "<div class=\"openclose\" tid=\"" + data.d.TicketID +"\"   style=\"float:right;position:relative;right:30px;" + displaythis + "\"><img src=\"../_images/checkboxclose.png\" tid=\"" + data.d.TicketID +"\"  class=\"opencloseaction\"  title=\"this action is closed\" alt=\"this action is closed\" id=\"actionopen_" + data.d.TicketData.TicketDataList[index].TicketDataID  +"\"  alt=\"select\" ></div>"
                                ticketdataisclose = false
                               }

       
                              
                                html += "<input type=\"text\"  " + disabletext + "  value=\"" + data.d.TicketData.TicketDataList[index].TicketTimeSpent + "\" id=\"actiontime_" +data.d.TicketData.TicketDataList[index].TicketDataID + "\"  name=\"actiontime_" +data.d.TicketData.TicketDataList[index].TicketDataID+ "\" style=\"width:30px\" />min"
                                html += "<input type=\"submit\" tid=\"" + data.d.TicketID +"\"  style=\"float:right;position:relative;right:25px" + hidedata +" \"  class=\"buttons\" name=\"saveaction_" + data.d.TicketData.TicketDataList[index].TicketDataID +"\"  value=\"" + saveaction  + "\" box=\"action\"  id=\"saveaction_" + data.d.TicketData.TicketDataList[index].TicketDataID +"\"  >"  
          
                            html += "</div>"


         

                            countreply ++


                        });

            html += "</div>"




            //save
           html += "<div class=\"savebutton\" id=\"save_" + data.d.TicketID +"\"  style=\"position:relative ; top:150px; float:right; clear:none;   \">"
           html +=  "<input type=\"submit\" class=\"buttons\"  tid=\"" + data.d.TicketID +"\"  name=\"SAVE\"  value=\"" + saveticket  + "\" style=\"float:right;position:relative;  background-image:none; background-color:red; right:0px " + displaythis +" \">"  
         html += "</div>"

           html += "<div  class=\"deltick\" id=\"deltick\"  style=\"position:relative ; top:150px; float:right; clear:none;display:none; \">"
           html +=  "<input type=\"submit\" class=\"buttons\"  tid=\"" + data.d.TicketID +"\"   value=\"Delete Ticket\"  />"
         
         
           html += "</div>"

            // Groups
            html += "<div  style=\"position:relative ; float:right; width:340px; padding-top:10px\">"
                  html +=  data.d.GroupAssign;
            html += "</div>"


            // New reply
            html += "<div  style=\"position:relative ; float:left; clear:both; width:600px;top:-20px;padding-bottom:20px \">"
                  html += "<a href=\"#\"  tid=\"" + data.d.TicketID +"\"  style=\"" + displaythis +  "\"  onclick=\" return false ,AddReply(" + data.d.TicketID +");\">+ New Reply</a>"
            html += "</div>"
            // Attachements
            html += "<div  style=\"position:relative ; float:left; clear:both; width:600px;top:-20px;padding-bottom:10px \">"
                 
                            html += "<div  style=\"position:relative ; float:left; clear:none; width:300px; padding-bottom:15px \">"
                             html += "<div style=\"clear:both;border-right:1px solid black ;border-left:1px solid black;border-top:1px solid black; width:100px; text-align:center \"><% = resx.GetString("ColumnName.Attachments") %></div>"
                                        
             
                            var attlist =  data.d.Attachments ;
                            var n=attlist.split(";"); 
                                

                            html += "<select size=\"4\" name=\"attachment" + data.d.TicketID +"\" id=\"attachment" + data.d.TicketID +"\"  class=\"attachment\" style=\"width:270px;\"> "
                                        for(i = 0; i < n.length; i++){

                                        if ( n[i].length > 1) {
                                           html += "<option value=\""  + n[i] +  "\">"+ n[i] +"</option>"

                                           }
                                }

                             html += "</select>"
                             html += "</div>"

                             html += "<div  style=\"position:relative ; float:left; clear:none; width:300px; padding-bottom:15px\">"
                                       html +=" <br><input type=\"file\"  id=\"browse" + data.d.TicketID +"\" class=\"browse\" style=\"width:280px\" name=\"browse" + data.d.TicketID +"\"  /><br>" 
                                       html += "<input type=\"submit\"  tid=\"" + data.d.TicketID +"\" class=\"buttons\"  name=\"download\" onclick=\" return false ,DownloadFile(" + data.d.TicketID +");\" value=\" <% = resx.GetString("buttons.btnDownloadBackupFile") %> \" style=\"float:right;position:relative;width:90px;  right:21px  " + displaythis +" \">"
                                       html += "<input type=\"submit\"  tid=\"" + data.d.TicketID +"\" class=\"buttons\"  name=\"delete\" onclick=\" return false ,DeleteFile(" + data.d.TicketID +");\" value=\" <% = resx.GetString("buttons.delete") %> \" style=\"float:right;position:relative; width:90px; right:21px   " + displaythis +" \">"
                                       html += "<img id=\"loading\" src=\"../_images/wait20.gif\" style=\"display:none;\"> " 
                             html += "</div>"
            html += "</div>"


                $(".expand" + TicketID).html(html);

             if (TicketID == 0) {
                 $("#deltick").show()

                 }

              // we just hide the New Ticket button till user enters correct dat . also hide the close ticket
               if ( $('#ticketcategory_'+ data.d.TicketID).find('option:selected').val() == 0) {  $("#newtick").hide() ;      $("#newticklable").show() ;    $("#deltick").show()  } else {
   
                //new hide save button when we can
                   $('#save_'+ data.d.TicketID).hide()
               }
                   
                  if (data.d.Closed == true ) {
                       $('.expand' + TicketID ).find('input, textarea , select, a').attr('disabled','disabled');
                 }
                   
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) { alert("TicketSingleReturn:" + textStatus + "-" + errorThrown); }
            });




          


           
        } // END OF UBER TICKET INSERT!

       
        // FILTERS
            function hidefilter(id) {
                $('#' + id).html('')
                  window.location.href = "TicketSupport.aspx?selectedstatus=" + $('#selectedstatus').html() + "&selectedissuetype=" + $('#selectedissuetype').html() + "&selectedcat=" + $('#selectedcat').html() + "&selectedproduct=" + $('#selectedproduct').html() + "&selectedpriority=" + $('#selectedpriority').html() + "&selectedmethod=" + $('#selectedmethod').html()  + "&DealerId=" + DealerID+ "&countryID=" + coutryid
            }
             function showfilter(id, selected) {
                $('#' + id).html(selected)
               window.location.href = "TicketSupport.aspx?selectedstatus=" + $('#selectedstatus').html() + "&selectedissuetype=" + $('#selectedissuetype').html() + "&selectedcat=" + $('#selectedcat').html() + "&selectedproduct=" + $('#selectedproduct').html() + "&selectedpriority=" + $('#selectedpriority').html() + "&selectedmethod=" + $('#selectedmethod').html() + "&DealerId=" + DealerID+ "&countryID=" + coutryid
            }

            function GetFilters() {
                FilterObjects.StatusID =    <%= FilterStatusID %>;
                FilterObjects.IssueTypeID = <%= FilterIssueTypeID %>;
                FilterObjects.CategoryID =  <%= FilterCategoryID %>;
                FilterObjects.ProductID =   <%= FilterProductID %>;
                FilterObjects.MethodID =    <%= FilterMethodID %>;
                FilterObjects.PriorityID =  <%= FilterPriorityID %>;
            }
    
        // END FILTERS



    function  getLists(dropdown,itemselect) {
          var drops =""
             $.each(eval(dropdown), function() {

                     switch (dropdown){
                             case "JsonPriority":

                 
                             if (itemselect == this.myPriority) {drops += "<option value=\""+ this.myPriorityID +"\" style=\"font-size:11px\" selected>" + this.myPriority +"</option>" } else 
                                                                {drops += "<option value=\""+ this.myPriorityID +"\" style=\"font-size:11px\" >" + this.myPriority +"</option>" }
                                   break;
                             case "JsonMethod":
                                  if (itemselect == this.myMethod) {drops += "<option value=\""+ this.myMethodID +"\" style=\"font-size:11px\" selected>" + this.myMethod +"</option>" } else 
                                                                   {drops += "<option value=\""+ this.myMethodID +"\" style=\"font-size:11px\" >" + this.myMethod +"</option>" }
                                    break;
                             case "JsonProduct":
                                   if (itemselect == this.myProduct) {drops += "<option value=\""+ this.myProductID +"\" style=\"font-size:11px\" selected>" + this.myProduct +"</option>" } else 
                                                                     {drops += "<option value=\""+ this.myProductID +"\" style=\"font-size:11px\" >" + this.myProduct +"</option>" } 
                                    break;
                             case "JsonCategory":
                                  if (itemselect == this.myCategory) {drops += "<option value=\""+ this.myCategoryID +"\" style=\"font-size:11px\" selected>" + this.myCategory+"</option>" } else 
                                                                     {drops += "<option value=\""+ this.myCategoryID +"\" style=\"font-size:11px\" >" + this.myCategory+"</option>" }
                                    break;
                             case "JsonIssueType":
                                   if (itemselect == this.myIssueType) {drops += "<option value=\""+ this.myIssueTypeID +"\" style=\"font-size:11px\" selected>" + this.myIssueType +"</option>" } else 
                                                                       {drops += "<option value=\""+ this.myIssueTypeID +"\" style=\"font-size:11px\" >" + this.myIssueType +"</option>"}
                                   break;
                             case "JsonContacts":
                                     if (itemselect == this) {drops += "<option value=\""+ this +"\" style=\"font-size:11px\" selected>" + this +"</option>" } else 
                                        {drops += "<option value=\""+ this +"\" style=\"font-size:11px\" >" + this +"</option>"}
                                   break;
                        }
              })

       return drops
    } 
       
       
   
    // attachments   
      function DeleteFile(tid) {
             if (document.getElementById('attachment' + tid).selectedIndex == -1) {
                    return false;
             }else { 
                var box = document.getElementById('attachment' + tid);
                var fullpathname =encodeURIComponent( uploadlocation + "\\" +  DealerID +   "\\Tickets\\" + tid  + "\\"  +  box.options[box.selectedIndex].text );

                            $.ajax({
                                url: folderName +"/Handlers/DeleteFile.ashx" ,
                                data: {DeleteFile: fullpathname},   
                                dataType: "json",
                                success: function (data) {                
                                                        if (typeof (data.error) != 'undefined') {
                                                            if (data.error != '') {
                                                                    alert('remove---' + data.error);              
                                                                    } else {
                                                                    $("#attachment" + tid +" option[value='" +  box.options[box.selectedIndex].text +"']").remove();
                                                                    }               
                                                                    }            
                                                },            
                                                    error: function (data) {    
                                                            $("#attachment" + tid +" option[value='" +  box.options[box.selectedIndex].text +"']").remove();  
                                                    }        
                                        }); 
                        return false;
                } 
          }



function AddtoGroup(dealer, tid , group){


                 $.ajax({
                            type: 'POST',  
                            async: false,
                            contentType: "application/json; charset=utf-8",
                            url: "<%= WebService %>/AddTicketGroup",
                            data: "{DealerID:'" + dealer + "',TicketID:'" + tid + "',GroupString:'" + group + "'}",
                            dataType: "json",
                            cache: false,
                            success: function (data) {
                                    if (data == "") {
                                        alert("No Group")
                                      } else {
                                    var togg =  $('#group_'  + tid ).slideToggle();
                                    
                                      GetTicket(tid)
                  
                                    }
                                },            
                                      error: function (data) {    
                                                         alert("Ticker Group Add Fail")
                                                    }    
                            })



}


    function ShowDealerGroup(tid){

  
            var r=confirm("WARING! Please save your Issue or Action boxes before you continue.\n \n Click Cancel to go back and save your text");
                if (r==true)
                         {
                                     $("#group_" + tid).empty();
                                        if ($('#group_'  + tid ).css('display') == 'none') {
                                                      $.ajax({
                                                            type: 'POST',  
                                                            async: false,
                                                            contentType: "application/json; charset=utf-8",
                                                            url: "<%= WebService %>/GetGroup",
                                                                data: "{DealerID:'" + DealerID + "',TicketID:'" + tid + "'}",
                                                            dataType: "json",
                                                            cache: false,
                                                            success: function (data) {
                                                                    if (data.d == "") {
                                                                        alert("No Group")
                                                                      } else {
                                                                    var togg =  $('#group_'  + tid ).slideToggle();
                                    
                                                                    $("#group_" + tid).append(data.d);
                  
                                                                    }
                                                                },            
                                                                      error: function (data) {    
                                                                                         alert("Ticket Email Failed")
                                                                                    }    
                                                            })
                                      }else {
                                        var togg =  $('#group_'  + tid ).slideToggle();
                                     }

                            }

    }


    function KillGroup(tid) {

   $('#group_'  + tid  ).hide()
    }

       function DownloadFile(tid) {
              if (document.getElementById('attachment' + tid).selectedIndex == -1) {
                          return false;
              }else { 
                 
                  var box = document.getElementById('attachment' + tid);
                  var fullpathname =uploadlocation + "\\" +  DealerID +   "\\Tickets\\" + tid  + "\\"  +  box.options[box.selectedIndex].text ;
                  location.href= folderName +"/Handlers/DownLoadFile.ashx?path=" + fullpathname;
                  return false;
              }
       }
          
          
       function ShowEamilPoP (tid) {
        var id = $('#emailticket_'  + tid).slideToggle();
      
        }   


            
       function eMailOpen(guid){
        // we need the localhost url of guid, as we use handeler to copy guid email to new location, reutnr back url and pop it open into a new window. 
                     $.ajax({
                             url: folderName +"/Handlers/OpenHTML.ashx" ,
                             data: {Guid: guid , Dealer: DealerID },   
                             dataType: "json",
                              success: function (data) {                
                                                     if (typeof (data) != 'undefined') {
                                                         if (data != '') { OpenEmail(data)    
                                                                          } else {  
                                                                            alert("error: " +data)  }               
                                                                }   
                                                                       
                                                },            
                                                 error: function (data) {    
                                                 alert(" eMailOpen error")
                                                          
                                                 }        
                         }); 
        }


        function OrderID(ord){
           window.location.href = "../_pts/orderHistory/OrderHistoryHistory.aspx?OrderID=" + ord
             }
        function search() {
            var coutryid = 1
            window.open('TicketSearch.aspx?dealerID=' +  DealerID + '&countryID=' +coutryid + '','mywindow','width=800,height=800,toolbar=no, location=yes,directories=yes,status=yes,menubar=no,scrollbars=yes,copyhistory=yes,resizable =yes')
          }
        function auditTrail(ticketid) {
              var coutryid = 1
             window.open('TicketAuditTrail.aspx?TicketID=' +  ticketid + '&countryID=' +coutryid  +'','mywindow','width=800,height=800,toolbar=no, location=yes,directories=yes,status=yes,menubar=no,scrollbars=yes,copyhistory=yes,resizable =yes')
        }
        function OpenEmail(data){
		         var PDFWindow = window.open( data ,'_email','width=700,height=600,status,resizable,scrollbars');PDFWindow.focus()                  		
                 PDFWindow.focus()
        }
	    function CreateOutlookEvent(TicketID){
			   var CreateOutlookEvent = window.open('CreateOutlookEvent.aspx?TicketID='+TicketID,'CreateOutlookEvent','width=50,height=40,status,scrollbars,resizable,toolbar');
			   CreateOutlookEvent.focus();			
		}
		


      function checksaveconditions(tid){

                SaveTicketObject.orderid =   $('#OrderID_'+ tid).val()
                SaveTicketObject.category =  $('#ticketcategory_'+ tid).find('option:selected').val(); 
                SaveTicketObject.categorytext =  $('#ticketcategory_'+ tid).find('option:selected').text(); 
                SaveTicketObject.method =   $('#ticketmethod_'+ tid).find('option:selected').val();
                SaveTicketObject.methodtext =   $('#ticketmethod_'+ tid).find('option:selected').text();
                SaveTicketObject.priority =  $('#ticketpriority_'+ tid).find('option:selected').val(); 
                SaveTicketObject.prioritytext =  $('#ticketpriority_'+ tid).find('option:selected').text(); 
                SaveTicketObject.product =   $('#ticketproduct_'+ tid).find('option:selected').val();
                SaveTicketObject.producttext =   $('#ticketproduct_'+ tid).find('option:selected').text();
                SaveTicketObject.issuetype =   $('#ticketissuetype_'+ tid).find('option:selected').val();
                SaveTicketObject.issuetypetext =   $('#ticketissuetype_'+ tid).find('option:selected').text();

                  if (SaveTicketObject.category == 0) {  alert("please select a category "); return false   }
                  if (SaveTicketObject.method == 0) {  alert("please select a method "); return false   }
                  if (SaveTicketObject.priority == 0) {  alert("please select a priority "); return false   }
                  if (SaveTicketObject.product == 0) {  alert("please select a product "); return false   }
                  if (SaveTicketObject.issuetype == 0) {  alert("please select a issuetype "); return false   }
                  if (SaveTicketObject.category == 0) {  alert("please select a category "); return false   }
    }







    </script>


    
<style>



#fade {display: none; background: #000;position: fixed;left: 0;top: 0;width: 100%;height: 100%;opacity: .80;	z-index: 9999;}
.popup_block {display: none; background: #fff;color: #2e2e2e;padding: 20px;border: 20px solid #ddd;float: left;font-family: "Helvetica Neue", Arial, Helvetica, sans-serif;font-size: 1.2em;line-height: 1.4em;letter-spacing: 0.03em;position: fixed;top: 50%;left: 50%;z-index: 99999;-webkit-box-shadow: 0px 0px 20px #000;-moz-box-shadow: 0px 0px 20px #000;box-shadow: 0px 0px 20px #000;-webkit-border-radius: 10px;-moz-border-radius: 10px;border-radius: 10px;}
.popup_block p {color: #2e2e2e;margin: 0;padding: 0px 0px 0px 0px;padding-bottom: 10px;}
.popup_block H1 {margin: 0;padding:10px 0px 10px 0px;color: #0082c8;font-size:1.8em;}
.popup_block H2 {margin: 0;padding:0px 0px 0px 0px;color: #919e97;font-size:1.0em;font-weight:bold;} /* grey intro text under page title*/
.popup_block H3 {margin: 0;padding:20px 0px 8px 0px;color: #0082c8;font-size:1.2em;text-transform:uppercase;}
.popup_block H4 {margin: 0;padding:10px 0px 10px 0px;color:#889194;font-size: 1.04em;text-transform:uppercase;}/* sub  category grey */
.popup_block H5 {margin: 0;padding: 0px;font-size: 1em;color: #0082c8;font-weight:bold;}
.popup_block H6 {font-size: 1em;font-weight: bold;color: #919e97;background: url(../images/squer.png) no-repeat;padding-bottom:3px;padding-left:15px;}
img.btn_close {float: right;margin: -55px -55px 0 0;}
*html #fade {position: absolute;}
*html .popup_block {position: absolute;}

</style>

        <script type="text/javascript" >
            $(document).ready(function () {

                $('a.poplight[href^=#]').live('click' ,function () {


                    var popID = $(this).attr('rel'); //Get Popup Name
                    var popURL = $(this).attr('href'); //Get Popup href to define size
                     // get text value
                    var issueaction  = $(this).attr('box')
                    var tdid  = $(this).attr('tdid')

                    var texty = $('#' + issueaction + '_' + tdid).val()
                    var query = popURL.split('?');
                    var dim = query[1].split('&');
                    var popWidth = dim[0].split('=')[1]; //Gets the first query string value
                    $('#' + popID).fadeIn().css({ 'width': Number(popWidth) }).prepend('<a href="#" class="close"><img src="../_images/closepopup.png" class="btn_close" title="Close Window" alt="Close" /></a>');
                    //Define margin for center alignment (vertical   horizontal) - we add 80px to the height/width to accomodate for the padding  and border width defined in the css
                    var popMargTop = ($('#' + popID).height() + 80) / 2;
                    var popMargLeft = ($('#' + popID).width() + 80) / 2;

                    //Apply Margin to Popup
                    $('#' + popID).css({
                        'margin-top': -popMargTop,
                        'margin-left': -popMargLeft
                    });
                    //Fade in Background
                    $('body').append('<div id="fade"></div>'); //Add the fade layer to bottom of the body tag.
                    $('#fade').css({ 'filter': 'alpha(opacity=80)' }).fadeIn(); //Fade in the fade layer - .css({'filter' : 'alpha(opacity=80)'}) is used to fix the IE Bug on fading transparencies 


                    globalpopupid = issueaction + '_' + tdid
                    $('#temptext').val(texty) // put the text into textbox
                    


                    return false;


                });


                //Close Popups and Fade Layer
                $('a.close, #fade').live('click', function () { //When clicking on the close or fade layer...
                    $('#fade , .popup_block').fadeOut(function () {
                        $('#fade, a.close').remove();  //fade them both out
                    });
                    return false;
                });




            });

            function savepopuopdate() {

 
             $('#' + globalpopupid).val($('#temptext').val())

                $('#fade , .popup_block').fadeOut(function () {
                    $('#fade, a.close').remove();  //fade them both out
                });

                 var savebuttonid_reply =''

                 if ( globalpopupid.split('_')[2] !== undefined) {
                    savebuttonid_reply = '_' + globalpopupid.split('_')[2]
                 }
  

                var savebuttonid = globalpopupid.split('_')[1];
                var saveactionorissue = globalpopupid.split('_')[0];

                $('#save' + saveactionorissue + '_' + savebuttonid + savebuttonid_reply).trigger("click");


                return false;

            }		
	</script>



<!--Parex.pts.general.Functions.ConvertIntegerToDate
  {"d":{"__type":"Parex.pts.general.Ticket","TicketID":1,"ExternalHelpDeskTicketID":"","TicketDate":"12/7/2012","TicketTask":"Request","TicketCategory":"Commercial","TicketProduct":"Transport Module","TicketPriority":"High","TicketMethod":"IncomingPhone","ContactPersonInternally":"colingraham","ContactPersonExternally":"Froome","Telephone":"+31 6256987","Closed":false,"LastChangeDate":"12/8/2012","LastChangedBy":"tom de winter","GuidEmail":"D:\\Dealer_Uploads\\parex\\parex_dealer_uploads/199/email/5ca75f5f-3993-49c2-bd0c-f2848fbd3f9a.html","TotalTime":95,"OrderID":"1258","CreatedBy":"",
  "TicketData":{"TicketDataList":[{"TicketID":1,"TicketDataID":2,"TicketClosed":false,"TicketIssueText":"parex not working","TicketActionText":"Restart IIIS","TicketTimeSpent":25,"TicketUpdatedBy":"colingraham","TicketDateCreated":"12/13/2012","TicketDateUpdated":"12/14/2012"},
                                  {"TicketID":1,"TicketDataID":1,"TicketClosed":false,"TicketIssueText":"customer needs help for stock file","TicketActionText":"c to the rescue","TicketTimeSpent":25,"TicketUpdatedBy":"colingraham","TicketDateCreated":"12/12/2012","TicketDateUpdated":"12/14/2012"}]}}-->

</head>
<body  class="tblBlock" >
    <form id="Form1" runat="server"  >


    <!-- address book -->
    	<input type="hidden" name="friend" /><input type="hidden" name="del" />

<!-- Filters -->
        <div  style="width: 800px; margin: 25px auto;"> 
     
     <table >
     <tr>
     <td>
      <ul class="dropdown">
                <asp:Label  ID="filtermenu" runat="server"></asp:Label>
        </ul>
		
     </td>
     
     
     <td  valign="top" style=" text-align:right">&nbsp;&nbsp;<asp:Button runat="server" ID="Button9"  Width="120"   CssClass="buttons" UseSubmitBehavior ="false"  OnClientClick="search();" /> <br />



     </tr>
     
     </table>

      
</div>
<!-- END Filters -->


<!-- INSERT TICKET -->
  <div class="container" >
          <input id="newtick" ntic="newtick"   type="button" class="buttons" value="+ New Ticket" onclick="LoadTicketData(0)" />
       

  <div style="float:right" ><asp:Label ID="lb_dealerid"  runat="server"></asp:Label></div><asp:TextBox  ID="tb_ticketidsearch" cssclass="ticketsearch"   runat="server" Width="120" Text="Search ID" onfocus="if(this.value=='Search ID') this.value='';" ></asp:TextBox>


   <div id="newticklable" style="display:none" ><b></b></div>

        <br /> <asp:Label ID="lb_noresults"  runat="server"></asp:Label>


        

</div>


    <asp:Repeater ID="repeaterTickets" runat="server">
    <ItemTemplate >
   
  
        <div class="container" >
           <div class="left"><img src="../_images/<%# LoadCorrectPlusMinus(Container.ItemIndex)%>.png" alt="select" id="<%#  DataBinder.Eval(Container.DataItem, "TicketID")%>" onclick="LoadTicketData(<%# DataBinder.Eval(Container.DataItem, "TicketID")%>)" /> </div>
    
        <div class="mid"   >  
              <div class="contract<%# DataBinder.Eval(Container.DataItem, "TicketID")%>" style="display:<%# LoadFullDisplayHeader(Container.ItemIndex, DataBinder.Eval(Container.DataItem, "TicketID"))%>" >    
              <table  width="100%"  cellpadding="0" cellspacing="0" border="0" style="font-size:10px ; line-height:20px;" >
               <tr>
                <td width="20px"  id="expireheader_<%# DataBinder.Eval(Container.DataItem, "TicketID")%>"   style="<%# TicketExpired(DataBinder.Eval(Container.DataItem, "Expired"))%>"   >#<%# DataBinder.Eval(Container.DataItem, "TicketID")%></td>
                <td width="100px"  class="tp_<%# DataBinder.Eval(Container.DataItem, "TicketID")%>" ><%# DataBinder.Eval(Container.DataItem, "TicketPriority")%></td>

                <td width="400px">
                         <%# DataBinder.Eval(Container.DataItem, "TicketCategory")%> /
                         <%# DataBinder.Eval(Container.DataItem, "TicketIssueType")%> / 
                         <%# DataBinder.Eval(Container.DataItem, "TicketMethod")%> /
                         <%# DataBinder.Eval(Container.DataItem, "TicketProduct")%>
                </td>

                <td width="100px" >Created:<%# DataBinder.Eval(Container.DataItem, "TicketCreatedDate") %></td>
                <td width="100px" >By:<%# DataBinder.Eval(Container.DataItem, "CreatedBy")%></td>

                <td width="100px" ><%# DataBinder.Eval(Container.DataItem, "LastChangeDate")%></td>
                </tr>
                </table> 
         </div>

        <div class="expand<%# DataBinder.Eval(Container.DataItem, "TicketID")%>" style="display:<%# LoadFullDisplayBody(Container.ItemIndex ,DataBinder.Eval(Container.DataItem, "TicketID"))%>; margin-top:10px;"  >  
     
        </div>
     </div>
     
    <div class="right" >  <img class="toggle"  id="statusimg_<%#  DataBinder.Eval(Container.DataItem, "TicketID")%>""  tid="<%# DataBinder.Eval(Container.DataItem, "TicketID")%>" src="../_images/<%# Loadopenorclosedimage(DataBinder.Eval(Container.DataItem, "Closed"))%>"  Title="<%# updateticketstatustitle(DataBinder.Eval(Container.DataItem, "Closed"))%>"   /> </div>
        </div>

   
        <br /><br />
         </ItemTemplate>
    </asp:Repeater>


    <div style=" height:300px">&nbsp</div>




<div id="popblock" class="popup_block">
	<div style=" overflow:auto; min-height:350px" > 
            <textarea id="temptext"  name="temptext" style="width:750px" cols="20" rows="20"></textarea>

            <img src="../_images/save.jpg" onclick="savepopuopdate()" />
	</div></div>




    </form>
</body>
</html>
