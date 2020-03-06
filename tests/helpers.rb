#
# test helper functions
#

class Helpers

  def self.pool_results_first_title( pool_results )
    titles = self.pool_results_all_titles( pool_results )
    return titles[0]
  end

  def self.pool_results_first_subject( pool_results )
    subjects = self.pool_results_all_subjects( pool_results )
    return subjects[0]
  end

  def self.pool_results_first_identifier( pool_results )
    identifiers = self.pool_results_all_identifiers( pool_results )
    return identifiers[0]
  end

  def self.pool_results_first_pub_date(pool_results)
    pub_dates = self.pool_results_all_pub_dates( pool_results )
    return pub_dates[0]
  end

  def self.pool_results_all_titles( pool_results )
    self.pool_results_all_values( pool_results, 'title' )
  end

  def self.pool_results_all_subjects( pool_results )
    self.pool_results_all_values( pool_results, 'subject' )
  end

  def self.pool_results_all_identifiers(pool_results)
    self.pool_results_all_values( pool_results, 'id' )
  end

  def self.pool_results_all_pub_dates( pool_results )
    self.pool_results_all_values( pool_results, 'publication_date' )
  end

  def self.pool_results_all_values( pool_results, field_name )

    all_values = []

    pool_results[:group_list].each do | group |
       group[:record_list].each do | record |
         record[:fields].each do | field |
           if field[:name] == field_name then all_values << field[:value] end
         end
       end
    end

    all_values
  end

end

#
# end of file
#
