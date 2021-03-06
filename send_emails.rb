# URL spreadsheet: https://docs.google.com/spreadsheets/d/1jyghXP3HOpl7MKuQcLuTw9_4JqDVT0M1TdtKItEJ5i0/edit#gid=1014134631

# On appelle les gems dont on a besoin
require 'gmail'
require 'google_drive'
require 'pry'

# On s'identifie chez Google via le fichier de config. Vous pouvez renseigner ici le chemin vers votre propre config.json.
session = GoogleDrive::Session.from_config("config.json")

# On récupère le worksheet
# Clé test: 1RlSByRRlXZFuqaOWyyZfF6T8RjV4i8-CX7Qs-Kef2QU
# Clé live: 1jyghXP3HOpl7MKuQcLuTw9_4JqDVT0M1TdtKItEJ5i0
@ws = session.spreadsheet_by_key("1RlSByRRlXZFuqaOWyyZfF6T8RjV4i8-CX7Qs-Kef2QU").worksheets[0]

# On se connect au compte Gmail. Vous pouvez remplacer par votre id avec @gmail.com et votre mdp.
@gmail = Gmail.connect("thpslacker@gmail.com", "B0rd3@ux33")

# Cette fonction recois un array de 2 éléments (nom_de_commune, email)
def send_email_to_line(array)
  townhall_name = array[0]
  townhall_email = array[1]

  #si l'adresse mail existe
  if townhall_name
    @gmail.deliver do
      from "The Hacking Project <thpslacker@gmail.com>"
      to townhall_email
      subject "Formez les jeunes et demandeurs d'emploi aux nouvelles technologies"
      text_part do
        # Optionnel, si pas précisé UTF8 par défaut
        content_type 'text/html; charset=UTF-8'
        body File.read('message.txt')
      end
      html_part do
        content_type 'text/html; charset=UTF-8'
        body get_the_email_html(townhall_name)
      end
    end
    p "Mail bien envoyé à #{townhall_name}"
  end
end

# Permet un bon formatage du texte dans le mail (html). Prend entré le nom de la commune et le prenom de l'utilisateur(optionnel).
# Important, de ne pas utiliser les "" dans le HTML mais plutôt les '', sinon on sort du string.
def get_the_email_html(townhall_name, prenom = "Eduardo")
  "<p style='color:black; font-family:Verdana; font-size:1em; text-align:justify'>Cher maire de #{townhall_name.split.map(&:capitalize).join(' ')},<br /><br />Je m'appelle #{prenom}, je suis élève à une formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau. La formation s'appelle <a href='http://thehackingproject.org/?ref=eduardo&src=eduardo&utm_source=eduardo' target='_blank'>The Hacking Project</a>. Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours, sur lesquel nous planchons en petites équipes autonomes. Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de <em>The Hacking Project</em> un nouveau format d'éducation gratuite.<br /><br />Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule à #{townhall_name.split.map(&:capitalize).join(' ')}, où vous pourriez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées. Le modèle d'éducation de <strong>The Hacking Project</strong> n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec #{townhall_name.split.map(&:capitalize).join(' ')} !<br /><br />Charles, co-fondateur de The Hacking Project, pourra répondre à toutes vos questions : <a href='tel:+33695466080'>06.95.46.60.80</a><br /><br />Bien à vous,<br /><br />- #{prenom}, Moussaillon à Bordeaux</p>"
end

# Parcourt toutes les linges du googleSheet. Chaque ligne est sous forme d'un array de 2 élements.
def go_through_all_the_lines()
  # Enlève les cases vide de l'array
  array = @ws.rows.compact
  array.each { |row| send_email_to_line(row) }
end

# L'exécution prend un peu de temps
go_through_all_the_lines()

# Se déconnecter
@gmail.logout
