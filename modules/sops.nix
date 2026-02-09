# Secrets management with sops-nix
{config, ...}: {
  # Configuration sops
  sops = {
    defaultSopsFile = ../secrets/cluster.yaml;

    # Clé age pour déchiffrer
    age.keyFile = "/home/nixos/.config/sops/age/keys.txt";

    # Secrets à déchiffrer
    secrets = {
      talosconfig = {
        owner = "nixos";
        group = "users";
        mode = "0600";
      };
      kubeconfig = {
        owner = "nixos";
        group = "users";
        mode = "0600";
      };
    };
  };

  # Variables d'environnement pour pointer vers les secrets déchiffrés
  environment.sessionVariables = {
    TALOSCONFIG = config.sops.secrets.talosconfig.path;
    KUBECONFIG = config.sops.secrets.kubeconfig.path;
  };
}
