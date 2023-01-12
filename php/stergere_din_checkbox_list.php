
<html>
<head>
  <title></title>
</head>
<body>
<h1>  </h1>

<?php


$lista_stergere=$_POST['lista_stergere'];

$lista=implode(",",$lista_stergere);
//$lista="'".$lista."'";

echo $lista;




 

   @ $db = new mysqli('localhost', 'webuser', 'webuser', 'lib4');

  if (mysqli_connect_errno()) 
  {
     echo 'Eroare! Conectarea la baza de date nu a reusit!';
     exit;
  }

 $interogare= 'delete from clienti where id_client in ('.$lista.');';


echo '<br>'.$interogare ;

  $result = $db->query($interogare);

  if ($result)
       echo  '<p>Nr linii sterse: '.$db->affected_rows; 

$db->close();


  
?>