module "files_root" {
  source = "./modules/files-configuration"

  folders = {
    brand = { name = local.northstar_files_names.brand }
  }
  files = {
    private_readme = {
      name          = local.northstar_files_names.private_file
      source_path   = "${path.root}/examples/files-configuration/assets/readme.txt"
      source_sha256 = "b958ea7d6f94c80be87c17e41f75fa658c095e18daeb3da7336e127e7e753bcf"
      folder_key    = "brand"
      access        = "PRIVATE"
    }
  }
}

module "files_brand" {
  source = "./modules/files-configuration"

  parent_folder_id = module.files_root.folder_ids["brand"]
  folders = {
    downloads = { name = local.northstar_files_names.downloads }
  }
  files = {
    public_logo = {
      name          = local.northstar_files_names.public_file
      source_path   = "${path.root}/examples/files-configuration/assets/northstar-logo.svg"
      source_sha256 = "81dadfbbd56c0ef4ab7c99faaa2c0e61cdd0c1df27e4288aed637130e1ad99df"
      folder_key    = "downloads"
      access        = "PUBLIC_NOT_INDEXABLE"
    }
  }
}
