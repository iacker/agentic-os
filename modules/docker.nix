# Module Docker avec configuration optimisée
{...}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };
}
