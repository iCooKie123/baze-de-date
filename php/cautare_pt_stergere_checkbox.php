<html>
<head>
  <title>Rezultate cautare</title>
</head>
<body>
<h1>Rezultate cautare</h1>
<?php







//foreach ($_POST['nume'] as $nume)
//{ echo $nume;}



 
  $searchtype=$_POST['searchtype'];
  $searchterm=$_POST['searchterm'];


  $searchterm= trim($searchterm);

  if (!$searchtype || !$searchterm)
  {
     echo 'Nu ati tiparit nimic.';
     exit;
  }



  @ $db = new mysqli('127.0.0.1', 'webuser', 'webuser', 'lib4');

  if (mysqli_connect_errno()) 
  {
     echo 'Eroare! Conectarea la baza de date nu a reusit!';
     exit;
  }

 $query = "select * from clienti where ".$searchtype." like '%".$searchterm."%'";


echo $query ;

  $result = $db->query($query);

  $num_results = $result->num_rows;

  echo '<p>Rezultatele cautarii: '.$num_results.'</p>';


echo '<form action="stergere_din_checkbox_list.php" method="post">
    <br />';






  for ($i=0; $i <$num_results; $i++)
  {
     $row = $result->fetch_assoc();

     echo '<input type="checkbox"  name="lista_stergere[]" value= "'.stripslashes($row['id_client']).'"> Nume: '.  stripslashes($row['nume']).'  Oras: '.stripslashes($row['oras']).'  Tel: '.stripslashes($row['telefon']); 
     echo '<br/>';
   
  }
echo '<br/>

    <input type="submit" value="Sterge">
  </form>';


  $db->close();

?>
</body>
</html>
