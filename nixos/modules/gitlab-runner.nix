{ pkgs, config, ... }:

{
  services.gitlab-runner = {
    enable = true;
    services = {
      # Название секции (произвольное)
      yc-course-runner = {
        # Путь к файлу с конфигом раннера
        authenticationTokenConfigFile = "/home/simon/.yc-gitlab-runner";

        # Выбираем исполнителя
        executor = "docker";

        # Дефолтный образ, если в .gitlab-ci.yml не указан image
        dockerImage = "alpine:latest";

        # Разрешаем запускать нетегированные пайплайны (runUntagged = true)
        dockerVolumes = [
          "/home/simon:/home/simon:rw"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        runUntagged = true;
      };
    };
  };
}
