variable "region"          {
    type    = string
    default = "us-central"
}

variable "project"         {
    type    = string
}

variable "secret"          {
    type    = string
}

variable "user"            {
    type    = string
}

variable "user-2"          {
    type    = string
}

variable "email"           {
    type    = string
}

variable "privatekeypath"  {
    type    = string
    default = "~/.ssh/id_rsa"
}

variable "publickeypath"   {
    type    = string
    default = "~/.ssh/id_rsa.pub"
}

variable "publickeypath-2" {
    type    = string
}

variable "user-2_path-to-dir"     {
    type    = string
}
