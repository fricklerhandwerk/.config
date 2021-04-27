self: super: {
  wine = super.wineWowPackages.staging;
  winetricks = super.winetricks.override { wine = self.wine; };
}
