<html>
  <head>
    <title></title>
    <script type="text/javascript" src="js/pdfobject.js"></script>
    <script type="text/javascript">
      window.onload = function (){
        var success = new PDFObject({ url: "UploadedKeys/test.pdf" }).embed();
         
      };
    </script>
  </head> 
  <body>
    <p>It appears you don't have Adobe Reader or PDF support in this web
    browser. <a href="UploadedKeys/test.pdf">Click here to download the PDF</a></p>
  </body>
</html>