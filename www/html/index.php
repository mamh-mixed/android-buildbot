<!--
To change this template, choose Tools | Templates
and open the template in the editor.
-->
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Marvell Semiconductor, Inc.</title>
		<script type="text/javascript" src="Login_files/jquery-1.3.2.js"></script>
		  <script type="text/javascript">
				function breakout_of_frame()
				{
					if (top.location != location) {
					
						top.location.href = document.location.href;
					}
				}

				$(document).ready(function() {
					var now = new Date();
					createCookie('UTCOffset',-now.getTimezoneOffset(), 1);

					breakout_of_frame();
					document.getElementById('name').focus();
				});
				
				function submitForm() {
				    /*
					var theForm = document.forms['form1'];
					
					if (!theForm) {
						theForm = document.form1;
						
					}
					alert(theForm);
					theForm.submit();
				     */
					 
					 $("#submit").click();
				}
				
				function createCookie(name, value, days) {
					if (days) {
						var date = new Date();
						date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
						var expires = "; expires=" + date.toGMTString();
					}
					else var expires = "";
					document.cookie = name + "=" + value + expires + "; path=/";
				}

				function MM_preloadImages() { //v3.0
				  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
					var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
					if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
				}
				function MM_swapImgRestore() { //v3.0
				  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
				}
				function MM_findObj(n, d) { //v4.01
				  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
					d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
				  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
				  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
				  if(!x && d.getElementById) x=d.getElementById(n); return x;
				}

				function MM_swapImage() { //v3.0
				  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
				   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
				}
</script>
		
		
		 <style type="text/css">
        html,body
        {
        	margin: 0;
        	padding: 0;
        }
        form
        {
        	position: absolute; 
        	top: 0px;
        	width: 100%;
        }
    </style>
<link href="Login_files/default.css" type="text/css" rel="stylesheet">
		
    </head>
    <body>
       <?php
            // If the name field is filled in
	    include('util.php');
            			
            if (isset($_POST['name']))
            {
                
                $name = $_POST['name'];
                 $pass = $_POST['pass'];
                 
                 $client=util::GetSOAPClient();
                  
                 $result=$client->AuthenticateExtranetUser(array("ExtranetUserName"=>$name,"ExtranetPassword"=>$pass));
                // $err=$client->getError();
//echo $err;
                 $resultArray=objectToArray($result);
           
                 if ($resultArray["Authenticated"])
                 {
                     //session_start();
                     
                     $_SESSION["useremail"]=$name;
                     
                     $connection= util::GetDBConnection("gerrit");
                     
                     if (mysqli_connect_errno($connection))
                     {
                         echo 'Error:' . mysqli_connect_error();
                     }                    
                     
                     
                     $query=  mysqli_query($connection, "select accounts.account_id, accounts.full_name, account_external_ids.external_id  FROM accounts, account_external_ids where accounts.account_id = account_external_ids.account_id and account_external_ids.external_id like 'username:%' and preferred_email='" . $name ."'");
                                                             
                     $rowcount=mysqli_num_rows($query);
                     
                     if ( $rowcount== 0)
                     {
                         header("location:Reg.php");
                     }
                     else
                     {
                         $row = mysqli_fetch_row($query);
                         $_SESSION["userid"]=$row[0];
                         $_SESSION["fullname"]=$row[1];
                         $_SESSION["gerritname"]=str_replace("username:","",$row[2]);
                         header("location:Files.php");
                     }
                     
                     $result->close();
                      
                 }
                 else
                 {
                     echo "Login failed!";
                 }
				  
            }
            
            function objectToArray($d) {
                if (is_object($d))
                {
                    $d=  get_object_vars($d);
                }
                
                if (is_array($d))
                {
                    return array_map(__FUNCTION__, $d);
                }
                else
                {
                    return $d;
                }
                    
            }
        ?>  
        <form action="index.php" method="post" name="form1" id="form1">
		 <table border="0" cellspacing="0" cellpadding="0" style="text-align:left">
            <tbody><tr>
                <td style="background-color: #eeeeee; height: 10px" colspan="2">&nbsp;</td>
            </tr>
              <tr>
                <td style="background-color: #eeeeee; height: 75px"><span class="style3"></span><img src="images/Marvell_logo.png" alt="logo" width="117" height="62" /></td>
                <td style="background-color: #eeeeee; height: 75px">&nbsp;</td>
              </tr>
            <tr>
                <td style="background-color: #cccccc; height: 5px" colspan="2"></td>
            </tr>
            <tr valign="top">
                <td style=" width:100%; background-image: url(images/bg_global_top_left.gif); background-position: top right; background-repeat: repeat-y">&nbsp;</td>
          <td>
                    <!-- global back top nav table -->
                    <table border="0" style="text-align:left;" cellpadding="0" cellspacing="0">
                        <tbody><tr>
                            <!-- global links  -->
                            <td align="right">&nbsp;</td>
                          <!-- /global links  -->
                        </tr>
                    </tbody></table>
                    <!-- /global back top nav table -->                </td>
            </tr>
        </tbody></table>
		<center>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <table width="344" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="344" height="101" colspan="3" background="images/login_GIT_III_01.jpg">&nbsp;</td>
              </tr>
              <tr>
                <td width="14" height="74" background="images/login_GIT_III_02.jpg">&nbsp;</td>
                <td width="72" height="74" background="images/login_GIT_III_03.jpg"><p class="style4">User ID</p>
                <p class="style4">Password</p></td>
                <td width="258" height="74" background="images/login_GIT_III_04.jpg"><p>
                  <input type="text" size="20" name="name" class="top_s_keyword" id="name" maxlength="50" style="border-color:#dddddd; border-width: thin" >
                </p>
                  <p><input type="password" size="20" name="pass" class="top_s_keyword" id="pass" maxlength="20" style="border-color:#dddddd; border-width: thin"  ></p></td>
              </tr>
              <tr>
                <td height="52" background="images/login_GIT_III_05.jpg">&nbsp;</td>
                <td background="images/login_GIT_III_06.jpg">&nbsp;</td>
                <td valign="top" background="images/login_GIT_III_07.jpg">
					<a href="#" onclick="submitForm();" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image2','','images/login_RO.jpg',1)">
						<img src="images/login_idel.jpg" name="Image2" width="70" height="22" border="0" id="Image2" />
					</a>
					<input type="submit" id="submit" name = "submit" value="" style="width:0px;height:0px;display:none;"/>
					
					</td>
              </tr>
            </table>
            <p>&nbsp;</p>
  </center>
		
             
            
         </form>
    </body>
</html>
