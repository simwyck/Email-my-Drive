# URL spreadsheet: https://docs.google.com/spreadsheets/d/1jyghXP3HOpl7MKuQcLuTw9_4JqDVT0M1TdtKItEJ5i0/edit#gid=1014134631

# On appelle les gems dont on a besoin
require 'gmail'
require 'google_drive'
require 'pry'

# M'identifie chez Google via le fichier de config. Ca utilise mon compte Google fake.
session = GoogleDrive::Session.from_config("config.json")

# On récupère le worksheet
# URLtest: https://docs.google.com/spreadsheets/d/1RlSByRRlXZFuqaOWyyZfF6T8RjV4i8-CX7Qs-Kef2QU/edit#gid=0
# URL live: https://docs.google.com/spreadsheets/d/1jyghXP3HOpl7MKuQcLuTw9_4JqDVT0M1TdtKItEJ5i0/edit?usp=drive_web
@ws = session.spreadsheet_by_key("1RlSByRRlXZFuqaOWyyZfF6T8RjV4i8-CX7Qs-Kef2QU").worksheets[0]

@gmail = Gmail.connect("thpslacker@gmail.com", "B0rd3@ux33") #penser à enlever les ids

# On récupère le contenu d'une cellule
# p ws[3, 2]

#cette fonction recois un array de 2 élements (nom_de_commune, email)
def send_email_to_line(array)
  townhall_name = array[0]
  townhall_email = array[1]

  #si l'adresse mail existe
  if townhall_name
    @gmail.deliver do
      from "Eduardo de THP <thpslacker@gmail.com>"
      to townhall_email
      #reply-to "simon@digitold.com"
      bcc "simon@digitold.com"
      subject "Formez les jeunes et demandeurs d'emploi aux nouvelles technologies"
      text_part do
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

#permet un bon formatage du texte dans le mail (html)
#prend entré le nom de la commune et le prenom de l'utilisateur(optionnel)
def get_the_email_html(townhall_name, prenom= "Eduardo")
  "<p style='color:black; font-family:Verdana; font-size:1em; text-align:justify'>Bonjour,<br /><br />Je m'appelle #{prenom}, je suis élève à une formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau. La formation s'appelle <a href='http://thehackingproject.org/?ref=eduardo&src=eduardo&utm_source=eduardo' target='_blank'>The Hacking Project</a>. Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours, sur lesquel nous planchons en petites équipes autonomes. Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de <em>The Hacking Project</em> un nouveau format d'éducation gratuite.<br /><br />Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule à #{townhall_name}, où vous pourriez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées. Le modèle d'éducation de <strong>The Hacking Project</strong> n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec #{townhall_name} !<br /><br />Charles, co-fondateur de The Hacking Project, pourra répondre à toutes vos questions : <a href='tel:+33695466080'>06.95.46.60.80</a><br /><br />Bien à vous,<br /><br />- Eduardo, Moussaillon à Bordeaux</p>"
end

#parcours toutes les linges du googleSheet
#chaque ligne est sous forme d'un array de deux élements
def go_through_all_the_lines()
  #enlève les cases vide de l'array
  array = @ws.rows.compact
  array.each{ |row| send_email_to_line(row) }
end

#l'exécution prend un peu de temps
go_through_all_the_lines()


=begin
# Envoyer un email
Gmail.connect("thpslacker@gmail.com", "B0rd3@ux33") do |gmail|
  gmail.deliver do
    from "Eduardo de THP <thpslacker@gmail.com>"
    to ws[3, 2]
    #cci "simon@digitold.com" Bloque le script, je ne sais pas pourquoi
    #reply-to "sim@me.com" Marche pas
    subject "Formez les jeunes et demandeurs d'emploi aux nouvelles technologies"
    text_part do
      body File.read('message.txt')
    end
    html_part do
      body File.read('message.html')
    end
    #add_file "/home/simwyck/Images/thp-logo-square.png"
  end
end

p "Message envoyé !"
=end

# Rapport d'erreurs. Pas testé
@mail = Mail.read('bounce_message.eml')
@mail.bounced?         #=> true
@mail.final_recipient  #=> rfc822;mikel@dont.exist.com
@mail.action           #=> failed
@mail.error_status     #=> 5.5.0
@mail.diagnostic_code  #=> smtp;550 Requested action not taken: mailbox unavailable
@mail.retryable?       #=> false

# Se déconnecter
# @gmail.logout
