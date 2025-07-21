import request from '@/utils/request'

// ����������֤��
export function sendStudentCodeApi(data) {
  return request.post('/student/sendCode', data)
}

// ע��ӿ�
export function registerStudentApi(data) {
  return request.post('/student/register', data)
}



export const login = (data) => {
    return service({
        url: "/base/login",
        method: 'post',
        data: data
    })
}

// @Summary ��ȡ��֤��
// @Produce  application/json
// @Param data body {username:"string",password:"string"}
// @Router /base/captcha [post]
/*
export const captcha = (data) => {
    return service({
        url: "/base/captcha",
        method: 'post',
        data: data
    })
}*/

// @Summary �û�ע��
// @Produce  application/json
// @Param data body {username:"string",password:"string"}
// @Router /base/resige [post]
export const register = (data) => {
    return service({
        url: "/base/register",
        method: 'post',
        data: data
    })
}

export const forgetSendEmail = (data) => {
    return service({
        url: "/base/forgetSendEmail",
        method: 'post',
        data: data
    })
}

export const forgetVerify = (data) => {
    return service({
        url: "/base/forgetVerify",
        method: 'post',
        data: data
    })
}

// @Summary �޸�����
// @Produce  application/json
// @Param data body {username:"string",password:"string",newPassword:"string"}
// @Router /user/changePassword [post]
export const changePassword = (data) => {
    return service({
        url: "/user/changePassword",
        method: 'post',
        data: data
    })
}
// @Tags User
// @Summary ��ҳ��ȡ�û��б�
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body modelInterface.PageInfo true "��ҳ��ȡ�û��б�"
// @Success 200 {string} json "{"success":true,"data":{},"msg":"��ȡ�ɹ�"}"
// @Router /user/getUserList [post]
export const getUserList = (data) => {
    return service({
        url: "/user/getUserList",
        method: 'post',
        data: data
    })
}


// @Tags User
// @Summary �����û�Ȩ��
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body api.SetUserAuth true "�����û�Ȩ��"
// @Success 200 {string} json "{"success":true,"data":{},"msg":"�޸ĳɹ�"}"
// @Router /user/setUserAuthority [post]
export const setUserAuthority = (data) => {
    return service({
        url: "/user/setUserAuthority",
        method: 'post',
        data: data
    })
}

export const resetPassword = (data) => {
    return service({
        url: "/user/resetPassword",
        method: 'post',
        data: data
    })
}

export const findSysUserById = (data) => {
    return service({
        url: "/user/findSysUserById",
        method: 'post',
        data: data
    })
}

export const deleteSysUser = (data) => {
    return service({
        url: "/user/deleteSysUser",
        method: 'post',
        data: data
    })
}

export const changeEmail = (data) => {
    return service({
        url: "/user/changeEmail",
        method: 'post',
        data: data
    })
}