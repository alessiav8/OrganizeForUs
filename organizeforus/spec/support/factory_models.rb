FactoryBot.define do
    factory(:user) do
      name {"Ale"}
      surname {"vol"}
      email {"al@gm.com"}
      username {"vol"}
      birthday {"2000-07-05"}
      password {"password"}
    end

    factory(:group) do
      name {"group_work"}
      description {"Group Description"}
      work { true }
      hours { 10 }
      date_of_start {"2022-07-05"}
      date_of_end {"2022-07-07"}
      strat_hour {"08:00:00"}
      end_hour {"17:00:00"}
    end

    factory(:post) do
      title {"Post"}
      body {"Post Description"}
    end

    factory(:survey) do
      title {"Survey"}
      body {"Survey Description"}
    end

    factory(:question) do
      title {"yes"}
    end

    factory(:event) do
      title {"Titolo Evento"}
      description {"Descrizione Evento"}
      start_date {"2022-08-08"}
      end_date {"2022-08-10"}
      mode {"Presence"}
      type_of_hours {"To take from to Group's hours"}
    end

end