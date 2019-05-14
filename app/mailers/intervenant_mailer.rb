class IntervenantMailer < ApplicationMailer

    def etat_services(intervenant_id, cours_ids, start_date, end_date)
        @cours = Cour.where(id:cours_ids)
        @intervenant = Intervenant.find(intervenant_id)
        @start_date = start_date
        @end_date = end_date
        mail(to: @intervenant.email, subject:"[PLANNING] Etat de services")
    end

    def notifier_cours_semaine_prochaine(intervenant, les_cours)
        logger.debug "[MAILER]"
        @les_cours = les_cours
        mail(to: intervenant.email, subject:"[PLANNING] Cours de la semaine prochaine")
    end

end
