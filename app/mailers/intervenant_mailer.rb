class IntervenantMailer < ApplicationMailer
    #default from: "IAE-Paris <planningiae@univ-paris1.fr>"
    default from: "IAE-Paris <planning-iae@philnoug.com>"

    def etat_services(intervenant_id, cours_ids, start_date, end_date)
        @cours = Cour.where(id:cours_ids)
        @intervenant = Intervenant.find(intervenant_id)
        @start_date = start_date
        @end_date = end_date
        mail(to: @intervenant.email, subject:"[PLANNING] Etat de services")
    end

    def notifier_cours(debut, fin, intervenant, cours, gestionnaires)
        @debut = debut
        @fin = fin
        @cours = cours
        @gestionnaires = gestionnaires
        @intervenant = intervenant
        mail(to: @intervenant.email, subject:"[PLANNING] Rappel de vos cours du #{l @debut} au #{l @fin}")
    end

end
