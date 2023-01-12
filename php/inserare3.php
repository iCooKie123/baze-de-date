<html>
<head>
  <title>Inserare client</title>
</head>
<body>
<h1>inserare client</h1>



<?php

  // datele din formular
  $nume=$_POST['nume'];
  $oras=$_POST['oras'];
  $tel=$_POST['telefon'];
  $id_client=$_POST['id_client'];





  @ $db = new mysqli('localhost', 'webuser', 'webuser', 'lib4');





  if (mysqli_connect_errno()) 
  {
     echo 'Error: Conexiunea la serverul mysql nu s-a facut. Incercati mai tarziu';
     exit;
  }



  $query = "update clienti set nume ='".$nume."',oras='".$oras."',telefon='".$tel."' where id_client=".$id_client;
            

echo $query;
echo "<br>";

  $result = $db->query($query);

  if ($result)
       echo  $db->affected_rows.' client updatat.'; 


  $db->close();


?>





</body>
</html>
