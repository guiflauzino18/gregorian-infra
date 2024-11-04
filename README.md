<h3>Sobre</h3>
Gregorian é um projeto pessoal de prática e aprefeiçoamento de desenvolvimento utilizando o framework Spring. A aplicação será uma API que posteriormente será consumida por uma aplicação web e futuramente uma aplicação mobile e se trata de uma agenda para terapeutas, com recursos como cadastro de pacientes, definição de agendas, configurações, permissões e elaborações de "laudos".

<h3>Deploy & Environment</h3>
Aplicação será executada em Docker e será implantada na AWS utilizandos os serviços de EC2 com Load Balancer e Autoscaling. Para fins de testes será implantada também utilizando o serviço de ECS, mas por questões de custos será utilizado majoritariamente o EC2.

Para banco de dados será utilizado o MySQL na versão 8.0 utilizando o serviço de RDS.

Deploy da aplicação, assim como a construção do ambiente, será implementando o recurso CI/CD utilizando a ferramenta GitHub Actions.

<h3>Sobre este Reposítório</h3>
Gregorian infra é um projeto IaC para deploy da aplicação (API) na nuvem aws, utilizando as ferramentas Terraform e GitHub Actions.
