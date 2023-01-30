{ config, ... }: {
  users.users.caretaker = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "navidrome"
    ];
    openssh.authorizedKeys.keys = [
      # melo
      # revol-xut
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6NLB8EHnUgl2GO2uaojdf3p3YpsHH6px6CZleif8klhLN+ro5KeFK2OXC2SO3Vo4qgF/NySdsoInV9JEsssELZ2ttVbeKxI6f76V5dZgGI7qoSf4E0TXIgpS9n9K2AEmRKr65uC2jgkSJuo/T1mF+4/Nzyo706FT/GGVoiBktgq9umbYX0vIQkTMFAcw921NwFCWFQcMYRruaH01tLu6HIAdJ9FVG8MAt84hCr4D4PobD6b029bHXTzcixsguRtl+q4fQAl3WK3HAxT+txN91CDoP2eENo3gbmdTBprD2RcB/hz5iI6IaY3p1+8fTX2ehvI3loRA8Qjr/xzkzMUlpA/8NLKbJD4YxNGgFbauEmEnlC8Evq2vMrxdDr2SjnBAUwzZ63Nq+pUoBNYG/c+h+eO/s7bjnJVe0m2/2ZqPj1jWQp4hGoNzzU1cQmy6TdEWJcg2c8ints5068HN3o0gQKkp1EseNrdB8SuG+me/c/uIOX8dPASgo3Yjv9IGLhhx8GOGQxHEQN9QFC4QyZt/rrAyGmlX342PBNYmmStgVWHiYCcMVUWGlsG0XvG6bvGgmMeHNVsDf6WdMQuLj9luvxJzrd4FlKX6O0X/sIaqMVSkhIbD2+vvKNqrii7JdUTntUPs89L5h9DoDqQWkL13Plg1iQt4/VYeKTbUhYYz1lw== revo-xut@plank"
      # 0xa gpg
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDP6xE2ey0C8XXfvniiiHiqXsCC277jKI9RXEA+s2LQLUI5zl7v350i3Oa8H3NCcPj39lfMreqE6ncxcOhqYyzahPrrMkOqgbPAoRvq8H3ophLK+56O3xdHoKwLBwRD1yoGACjqG4UTiTrmnN2ateENgYcnTEY1e4vDw1qMj1drUXCsZ/6mkBBmHJiFfCaR4yCMt1r4gGi/dAC7ifnBP3oSyV/lJEwPxYYkGlbOBIvX/7Ar98pJS6xYPB3jHs9gwyNNON63d0fNYrwBojXPPCnGGaRZNOkBTzex3zZYp12ThINQ2xl8tRp9D8qpZ7vrLjhTD6AXkOBRzmDj+NsCeEaeTuWajqUM93iKncYUI+JxR1t7q8gA2pBMFzLesMXnx7R+5Kw7QDtSJM7a4GMIfsocPwf64BH6rzxEz68rXFE3P+J77PPM9CuaYw90JXHo3z220zYw2nMQ/1qjATVZw/hiVrLmQMVfmFJIufnGjTBs2sy3IoNyzvYm/oDeNNg1cdSV9gyyRKZhK08fxjXN5GSf9vZkfZa9tHtqaZ99HI40GQBHUVx1K2/NQJY8TVTSA+v16SFnJK8BIbmp/WFCuvDcMkgLIbqiYtDASe7P2mKIib86uOENT+P820egeLiTQ06kFw/gfUa8t69d5qEcjiQZ+lxCeYIs/E9KrEXHvRUWew== cardno:16 811 348"
    ];
  };
}
