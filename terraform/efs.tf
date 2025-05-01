# efs
resource "aws_efs_file_system" "mongodb-efs" {
  creation_token   = "mongodb-efs"
  performance_mode = "generalPurpose"
  tags = {
    Name = "mongodb-efs"
  }
}

# efs access point 
resource "aws_efs_access_point" "mongodb-efs-access-point" {
  file_system_id = aws_efs_file_system.mongodb-efs.id
#   root_directory {
#     creation_info {
#       owner_uid   = "1000"
#       owner_gid   = "1000"
#       permissions = 770
#     }
#     path = "/"
#   }
}
