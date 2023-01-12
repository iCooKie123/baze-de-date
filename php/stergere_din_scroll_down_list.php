<?php

$lista='';

foreach ($_POST['nume'] as $nume)
{ $lista=$lista.','. $nume;}

$lista='-1'.$lista;


echo '<br>'.$lista;


   @ $db = new mysqli('127.0.0.1', 'webuser', 'webuser', 'lib4');

  if (mysqli_connect_errno()) 
  {
     echo 'Eroare! Conectarea la baza de date nu a reusit!';
     exit;
  }

 $query = 'delete from clienti where id_client in ('.$lista.');';


echo '<br>'.$query ;

  $result = $db->query($query);

  if ($result)
       echo  '<p>Nr linii sterse: '.$db->affected_rows; 

$db->close();
?>