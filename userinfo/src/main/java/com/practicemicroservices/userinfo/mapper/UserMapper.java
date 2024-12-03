package com.practicemicroservices.userinfo.mapper;

import com.practicemicroservices.userinfo.dto.UserDTO;
import com.practicemicroservices.userinfo.entity.User;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper
public interface UserMapper {
    UserMapper INSTANCE= Mappers.getMapper(UserMapper.class);

    User mapUserDTOToUser(UserDTO userDTO);
    UserDTO mapUserTOUserDTO (User user);
}
