<html>
<head>
  <title>Rezultate cautare</title>
</head>
<body>
<h1>Rezultate cautare</h1>


<?php
 
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

  for ($i=0; $i <$num_results; $i++)
  {
     $row = $result->fetch_assoc();
     echo '<p><strong>'.($i+0).'. id client: ';
     echo stripslashes($row['id_client']);
     echo '</strong><br />Nume: ';
     echo stripslashes($row['nume']);
     echo '<br />Oras: ';
     echo stripslashes($row['oras']);
     echo '<br />Telefon: ';
     echo stripslashes($row['telefon']);
     echo '</p>';
  }
  
  $db->close();

?>
</body>
</html>
