
<html>
<head>
  <title></title>
</head>
<body>
<h1>  </h1>

<?php

echo  $_POST['client'];

if(!isset($_POST['client'])) 
{ echo 'nu ati selectat nimic!'; 
exit;}
   else{
     $id_selectat=$_POST['client'];


   @ $db = new mysqli('localhost', 'webuser', 'webuser', 'lib4');

  if (mysqli_connect_errno()) 
  {
     echo 'Eroare! Conectarea la baza de date nu a reusit!';
     exit;
  }

  $interogare= 'select * from clienti where id_client='.$id_selectat;


echo '<br>'.$interogare ;
echo '<br/>';

  $result = $db->query($interogare);


echo '<form action="inserare3.php" method="post">
    <br />';



  if($result){
  $row = $result->fetch_assoc();


  echo 'Formular updatare informatii client <br>';

     echo 'Id client: '.stripslashes($row['id_client']);
     echo '<input type ="hidden"  name="id_client"  value="'.$row['id_client'].'" > ';



     echo   ' <br/> Nume: ';
   echo '<input type ="text"  name="nume"  value="'.$row['nume'].'" > ';


   echo ' <br/>   Oras: ' ;
  echo '<input type ="text"  name="oras"  value="'.$row['oras'].'" > ';

  echo ' <br/>   Tel: ';
  echo '<input type ="text"  name="telefon"  value="'.$row['telefon'].'" > ';


     echo '<br/>';
echo ' <input type="submit" value="Updateaza">';

 $result->free();
  }

$db->close();


  }
?>