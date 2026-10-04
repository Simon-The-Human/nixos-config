{ pkgs, config, ... }:

{
  # Включаем Docker, если используем docker executor
  virtualisation.docker.enable = true;

  services.gitlab-runner = {
    enable = true;
    services = {
      # Название секции (произвольное)
      yc-course-runner = {
        # Указываем URL вашего GitLab
        gitlabUrl = "http://10.92.14.137";

        # Путь к файлу с токеном регистрации
        registrationConfigFile = "./gitlab-runner-token";

        # Выбираем исполнителя
        executor = "docker";

        # Дефолтный образ, если в .gitlab-ci.yml не указан image
        dockerImage = "alpine:latest";

        # Разрешаем запускать нетегированные пайплайны (runUntagged = true)
        tagList = [ "docker" ];
      };
    };
  };
}
