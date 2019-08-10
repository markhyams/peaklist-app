class FilePersistence
  def load_peaks_sorted(sort_by, reverse)
    Peak.sort_records(sort_by, reverse)
  end
  
  def load_ascents_sorted(sort_by, reverse)
    Ascent.sort_records(sort_by, reverse)
  end
  
  def load_users_sorted(sort_by, reverse)
    User.sort_records(sort_by, reverse)
  end
  
  def create_new_user(data)
    User.create_new_user(data)
  end
  
  def load_user_by_username(username)
    User.load_user(username)
  end
  
  def load_user_by_id(id)
    User.load_user_by_id(id)
  end
  
  def load_peak_by_id(id)
    Peak.load_peak_by_id(id)
  end
  
  def load_ascents_by_user(user)
    user.user_ascents
  end
  
  def load_peaks_by_user(user)
    user.unique_peaks
  end
  
  def load_ascent_by_id(id)
    Ascent.load_record_by_id(id)
  end
  
  def edit_ascent(data)
    Ascent.edit_ascent(data)
  end
  
  def delete_ascent(id)
    Ascent.delete_ascent(id)
  end
  
  def create_ascent(data)
    Ascent.create_new_ascent(data)
  end
end
