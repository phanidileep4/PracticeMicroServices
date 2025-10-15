package com.practicemicroservices.foodcatalogue.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Food Catalogue Service API")
                        .version("v1")
                        .description("APIs for Food Catalogue Service"))
                .servers(List.of(
                    new Server().url("https://foodcatalogue-service-oqfd2ssuua-uc.a.run.app").description("Production server (GCP)"),
                    new Server().url("http://localhost:9095").description("Local development server")
                ));
    }
}