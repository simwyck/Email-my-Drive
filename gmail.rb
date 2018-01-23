# First of all require the gmail library.
require 'gmail'

#gmail.inbox.count

=begin
Gmail.connect(thpslacker@gmail.com, B0rd3@ux33) do |gmail|
  gmail.logged_in?
end
=end

# Se connecter et checker le statut
=begin
Gmail.connect("thpslacker@gmail.com", "B0rd3@ux33") do |gmail|
  gmail.logged_in?
end
=end

# Envoyer un email
Gmail.connect("thpslacker@gmail.com", "B0rd3@ux33") do |gmail|
  gmail.deliver do
    from "THP Slacker <thpslacker@gmail.com>"
    to "thpslacker@gmail.com"
    subject "Having fun in Punta Cana!"
    text_part do
      body "Text of plaintext message.\n My second line."
    end
    html_part do
      content_type 'text/html; charset=UTF-8'
      body "<p>Text of <em>html</em> message.<br />My second line.</p>"
    end
    add_file "/home/simwyck/Images/thp-logo-square.png"
  end
end

p "Message envoyé !"

# Se déconnecter
#gmail.logout

#If you pass a block, the session will be passed into the block, and the session will be logged out after the block is executed.
=begin
Gmail.connect(username, password) do |gmail|
  # play with your gmail...
end
=end
