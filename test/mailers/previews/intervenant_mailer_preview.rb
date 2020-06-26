# Preview all emails at http://localhost:3000/rails/mailers/intervenant_mailer
class IntervenantMailerPreview < ActionMailer::Preview
    def notifier_cours
        IntervenantMailer.notifier_cours(Date.today, 
                                        Date.today.end_of_month, 
                                        Intervenant.last, 
                                        Intervenant.last.cours.last(6),
                                        {"MBA lkjlkjlkjl": "regis@iae-paris.com", 
                                         "MBA SANTE 2019/2020": "laigle@iae-paris.com"})
    end
end
