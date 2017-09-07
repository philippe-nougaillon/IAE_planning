class IntervenantMailer < ApplicationMailer

    def etat_services(intervenant, cours, start_date, end_date)
        @cours = cours
        @intervenant = intervenant
        @start_date = start_date
        @end_date = end_date
        mail(to: @intervenant.email, subject:"[PLANNING] Etat de services")
    end

end
