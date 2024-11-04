#Arqivo de configuração do backend do terraform
#Informa que tfstate será salvo no s3. Ao executar terraform init é passado os valores do bucket region e key.
/*
              run: cd infra/env/${{inputs.environment}} && terraform init 
                  -backend-config="bucket=${{inputs.aws-bucket-statefile}}"  
                  -backend-config="key=${{github.event.repository.name}}" 
                  -backend-config="region=${{inputs.aws-region}}" 
*/
terraform {
  backend "s3" {} 
}