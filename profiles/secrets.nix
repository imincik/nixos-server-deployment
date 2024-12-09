{ config, pkgs, ... }:

{
  age.secrets = {
    mySecret1 = {
      file = ../secrets/mySecret1.age;
    };

    mySecret2 = {
      file = ../secrets/mySecret2.age;
    };
  };

  # files containing secret
  environment.etc = {
    mySecretFile1 = {
      source = config.age.secrets.mySecret1.path;
      target = "my-secret-file1";
      mode = "0440";
    };

    mySecretFile2 = {
      source = config.age.secrets.mySecret2.path;
      target = "my-secret-file2";
      mode = "0440";
    };
  };
}
