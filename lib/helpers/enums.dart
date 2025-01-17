// ignore_for_file: constant_identifier_names

enum CollectionNames {
  users,
  user_profiles,
  user_roles,
  role_privileges,
  research_projects,
  categories,
  uploads,
  documentuploads,
}

enum UserRoles {
  admin,
  viewer,
  subscribed
}

enum CrudActionMessages {
   added,
   updated,
   deleted,
   error
}

enum FormModes {
  add,
  update
}