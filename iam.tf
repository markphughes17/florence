resource "aws_iam_user" "generatedhealthusers" {
  count = "${length(var.username)}"
  name = "${element(var.username,count.index )}"
}