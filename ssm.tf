#Instance Role
resource "aws_iam_role" "test_role" {
  name = "test-ssm-ec2"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "test-ssm-ec2"
    createdBy = "MaureenBarasa"
    Owner = "DevSecOps"
    Project = "test-terraform"
    environment = "test"
  }
}

#Instance Profile
resource "aws_iam_instance_profile" "test_profile" {
  name = "test-ssm-ec2"
  role = "${aws_iam_role.test_role.id}"
}

#Attach Policies to Instance Role
resource "aws_iam_policy_attachment" "test_attach1" {
  name       = "test-attachment"
  roles      = [aws_iam_role.test_role.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# resource "aws_iam_policy_attachment" "test_attach2" {
#   name       = "test-attachment"
#   roles      = [aws_iam_role.test_role.id]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
# }

resource "aws_iam_policy_attachment" "test_attach3" {
  name       = "test-attachment"
  roles      = [aws_iam_role.test_role.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}