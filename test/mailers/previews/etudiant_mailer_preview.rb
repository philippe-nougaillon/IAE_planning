# Preview all emails at http://localhost:3000/rails/mailers/etudiant_mailer
class EtudiantMailerPreview < ActionMailer::Preview

    def notifier_modification_cours
        cours = Cour.find(20502)
        EtudiantMailer.notifier_modification_cours(Etudiant.first, cours) 
    end

end
