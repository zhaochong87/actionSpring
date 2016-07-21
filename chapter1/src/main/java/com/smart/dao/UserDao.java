package com.smart.dao;

import com.smart.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by Administrator on 2016/6/5.
 */
@Repository
public class UserDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    public int getMatchCount(String userName, String password){
        String sql = " SELECT count(*) FROM t_user WHERE user_name =? AND password =? ";
        return jdbcTemplate.queryForInt(sql, new Object[]{userName, password});
    }

    public User findUserByUserName(final String userName){
        String sql = " SELECT user_id,user_name "
                + " FROM t_user WHERE user_name =? ";
        final User user = new User();
        jdbcTemplate.query(sql, new Object[]{userName},
                new RowCallbackHandler() {
                    public void processRow(ResultSet resultSet) throws SQLException {
                        user.setUserId(resultSet.getInt("user_id"));
//                        user.setUserName("userName");
                        user.setUserName(resultSet.getString("user_name"));
                    }
                });
        return user;
    }

    public void uadateLoginInfo(User user){
        String sql = " UPDATE t_user SET last_visit=?,last_ip=?"
                + " WHERE user_id =?";
        jdbcTemplate.update(sql, new Object[]{user.getLastVisit(),
                user.getLastIp(), user.getUserId()});
    }
}
