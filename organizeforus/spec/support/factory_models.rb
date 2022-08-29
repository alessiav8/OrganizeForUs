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

end