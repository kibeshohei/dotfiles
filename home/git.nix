{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "kibeshohei";
      user.email = "251728327+kibeshohei@users.noreply.github.com";
      credential."https://github.com".helper = [
        ""
        "!gh auth git-credential"
      ];
    };
  };
}
