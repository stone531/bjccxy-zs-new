<template>
  <div>
    <div class="gva-search-box">
      <el-form ref="searchForm" :inline="true" :model="searchInfo">
        
        <el-form-item label="创建日期" prop="createdAt">
          <template #label>
            <span>
              创建日期
              <el-tooltip
                content="搜索范围是开始日期（包含）至结束日期（不包含）"
              >
                <el-icon><QuestionFilled /></el-icon>
              </el-tooltip>
            </span>
          </template>
          <el-date-picker
            v-model="searchInfo.sdate"
            type="datetime"
            placeholder="开始日期"
            :disabled-date="
              (time) =>
                searchInfo.edate
                  ? time.getTime() > searchInfo.edate.getTime()
                  : false
            "
          ></el-date-picker>
          —
          <el-date-picker
            v-model="searchInfo.edate"
            type="datetime"
            placeholder="结束日期"
            :disabled-date="
              (time) =>
                searchInfo.sdate
                  ? time.getTime() < searchInfo.sdate.getTime()
                  : false
            "
          ></el-date-picker>
        </el-form-item>
        
        
        <el-form-item label="姓名">
          <el-input v-model="searchInfo.name" placeholder="姓名" />
        </el-form-item>
        <el-form-item label="毕业证书编号">
          <el-input v-model="searchInfo.graduschool" placeholder="毕业证书编号" />
        </el-form-item>
        <el-form-item label="录入人员">
          <el-input v-model="searchInfo.editer" placeholder="录入人员" />
        </el-form-item>

        <el-form-item>
          <el-button type="primary" icon="search" @click="onSubmit">
            查询
          </el-button>
          <el-button icon="refresh" @click="onReset"> 重置 </el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="gva-table-box">
      <div class="gva-btn-list">
        <el-button type="primary" icon="plus" @click="addUser"
          >新增用户</el-button
        >
      </div>

      <el-table :data="tableData" row-key="ID">
        <el-table-column align="left" label="ID" min-width="90" prop="ID" />
        <el-table-column
          align="left"
          label="学员姓名"
          min-width="100"
          prop="name"
        />
        
        <el-table-column prop="sex" label="性别">
          <template #default="{ row }">
            {{ row.sex === 1 ? '男' : row.sex === 2 ? '女' : '未知' }}
          </template>
        </el-table-column>
        

        <el-table-column
          align="left"
          label="籍贯"
          min-width="70"
          prop="nativeplace"
        />
        <el-table-column
          align="left"
          label="身份证号"
          min-width="180"
          prop="certificatenumber2"
        />
        <el-table-column
          align="left"
          label="毕业证号"
          min-width="180"
          prop="graduschool"
        />
        <el-table-column
          align="left"
          label="录入日期"
          min-width="180"
          prop="CreatedAt"
        >
          <template #default="{ row }">
            {{ formatDate(row.CreatedAt) }}
          </template>
        </el-table-column>
        
        <el-table-column
          align="left"
          label="录入人员"
          min-width="180"
          prop="editer"
        />

        <el-table-column label="操作" :min-width="appStore.operateMinWith" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              link
              icon="delete"
              @click="deleteUserFunc(scope.row)"
              >删除</el-button
            >
            <el-button
              type="primary"
              link
              icon="edit"
              @click="openEdit(scope.row)"
              >编辑</el-button
            >
            <el-button
              type="primary"
              link
              icon="magic-stick"
              @click="zhengshuDetailFunc(scope.row)"
              >详情</el-button
            >
          </template>
        </el-table-column>
      </el-table>
      <div class="gva-pagination">
        <el-pagination
          :current-page="page"
          :page-size="pageSize"
          :page-sizes="[10, 30, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @current-change="handleCurrentChange"
          @size-change="handleSizeChange"
        />
      </div>
    </div>

     <!-- 更新用户信息 -->
    <el-drawer
      v-model="addUserDialog"
      :size="appStore.drawerSize"
      :show-close="false"
      :close-on-press-escape="false"
      :close-on-click-modal="false"
    >
      <template #header>
        <div class="flex justify-between items-center">
          <span class="text-lg">修改用户信息</span>
          <div>
            <el-button @click="closeAddUserDialog">取 消</el-button>
            <el-button type="primary" @click="enterAddUserDialog"
              >确 定</el-button
            >
          </div>
        </div>
      </template>

      <el-form
        ref="userForm"
        :rules="rules"
        :model="userInfo"
        label-width="80px"
      >

        <el-form-item label="用户名" prop="name">
          <el-input v-model="userInfo.name" style="width: 200px" />
        </el-form-item>

        <el-form-item label="性别" prop="sex">
          <el-radio-group v-model="userInfo.sex">
            <el-radio :label="1">男</el-radio>
            <el-radio :label="2">女</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="出生年月" prop="age">
          <el-date-picker
            v-model="userInfo.age"
            type="date"
            placeholder="选择出生年月"
            style="width: 200px"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>

        <el-form-item label="民族" prop="mingzhu">
          <el-select v-model="userInfo.mingzhu" placeholder="请选择民族" style="width: 200px">
            <el-option v-for="item in nations" :key="item" :label="item" :value="item" />
          </el-select>
        </el-form-item>

        <el-form-item label="证件照片" prop="pic" label-width="80px">
          <SelectImage v-model="userInfo.pic" />
        </el-form-item>

        <el-form-item label="籍贯" prop="nativeplace">
          <el-select v-model="userInfo.nativeplace" placeholder="请选择籍贯" style="width: 200px" filterable>
            <el-option v-for="place in nativeplaces" :key="place" :label="place" :value="place" />
          </el-select>
        </el-form-item>

        <el-form-item label="身份证号" prop="certificatenumber2">
          <el-input
            v-model="userInfo.certificatenumber2"
            style="width: 200px"
            placeholder="请输入18位身份证号码"
          />
        </el-form-item>

        <el-form-item label="专业" prop="zhuanye">
          <el-input v-model="userInfo.zhuanye" style="width: 200px" />
        </el-form-item>

        <el-form-item label="毕业时间" prop="bysj">
          <el-date-picker
            v-model="userInfo.bysj"
            type="month"
            placeholder="选择毕业年月"
            style="width: 200px"
            value-format="YYYY-MM"
          />
        </el-form-item>
      </el-form>  

    </el-drawer>
  </div>
</template>

<script setup>
  import {
    getZhengshuList,
    delZhengshuById,
    setZhengshuInfo
  } from '@/api/user'

  import { getAuthorityList } from '@/api/authority'
  import { setUserInfo, resetPassword } from '@/api/user.js'
  import SelectImage from '@/components/upload/zsCommon.vue'
  //import zhengshuInfo from '@/view/business/certificate/certificateInfo.vue'
  import { nextTick, ref, watch } from 'vue'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import { useAppStore } from "@/pinia";
  import { useRouter } from 'vue-router'
  import dayjs from 'dayjs'

  defineOptions({
    name: 'certificateQuery'
  })

  const appStore = useAppStore()
  const router = useRouter()

  const searchInfo = ref({
    name: '',
    editor: '',
    graduschool: '',
    sdate: '',
    edate: ''
  })
  
  const onSubmit = () => {
    page.value = 1
    getTableData()
  }

  const onReset = () => {
    searchInfo.value = {
      username: '',
      nickname: '',
      phone: '',
      email: ''
    }
    getTableData()
  }
  // 初始化相关
  const setAuthorityOptions = (AuthorityData, optionsData) => {
    AuthorityData &&
      AuthorityData.forEach((item) => {
        if (item.children && item.children.length) {
          const option = {
            authorityId: item.authorityId,
            authorityName: item.authorityName,
            children: []
          }
          setAuthorityOptions(item.children, option.children)
          optionsData.push(option)
        } else {
          const option = {
            authorityId: item.authorityId,
            authorityName: item.authorityName
          }
          optionsData.push(option)
        }
      })
  }

  const page = ref(1)
  const total = ref(0)
  const pageSize = ref(10)
  const tableData = ref([])
  // 分页
  const handleSizeChange = (val) => {
    pageSize.value = val
    getTableData()
  }

  const handleCurrentChange = (val) => {
    page.value = val
    getTableData()
  }

  // 查询
  const getTableData = async () => {
    const table = await getZhengshuList({
      page: page.value,
      pageSize: pageSize.value,
      ...searchInfo.value
    })
    if (table.code === 0) {
      tableData.value = table.data.list
      total.value = table.data.total
      page.value = table.data.page
      pageSize.value = table.data.pageSize
    }
  }

  watch(
    () => tableData.value,
    () => {
      setAuthorityIds()
    }
  )

  const initPage = async () => {
    getTableData()
    //const res = await getAuthorityList()
    //setOptions(res.data)
  }

  initPage()

  // 重置密码对话框相关
  const resetPwdDialog = ref(false)
  const resetPwdForm = ref(null)
  const resetPwdInfo = ref({
    ID: '',
    userName: '',
    nickName: '',
    password: ''
  })
  
  // 查询出来的表数据和页面对应上
  const setAuthorityIds = () => {
    tableData.value &&
      tableData.value.forEach((user) => {
        user.authorityIds =
          user.authorities &&
          user.authorities.map((i) => {
            return i.authorityId
          })
      })
  }
  
  // 确认重置密码

  const deleteUserFunc = async (row) => {
    ElMessageBox.confirm('确定要删除吗?', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(async () => {
      const res = await delZhengshuById({ id: row.ID })
      if (res.code === 0) {
        ElMessage.success('删除成功')
        await getTableData()
      }
    })
  }

  // 弹窗相关
  const userInfo = ref({
    name: '',
    age: '',
    sex: '',
    mingzhu: '',
    pic: '',
    nativeplace: '',
    bysj: '',
    zhuanye:'',
    certificatenumber2:''
  })

  const nations = [
  "汉族", "蒙古族", "回族", "藏族", "维吾尔族", "苗族", "彝族", "壮族", "布依族", "朝鲜族",
  "满族", "侗族", "瑶族", "白族", "土家族", "哈尼族", "哈萨克族", "傣族", "黎族", "傈僳族",
  "佤族", "畲族", "高山族", "拉祜族", "水族", "东乡族", "纳西族", "景颇族", "柯尔克孜族", "土族",
  "达斡尔族", "仫佬族", "羌族", "布朗族", "撒拉族", "毛南族", "仡佬族", "锡伯族", "阿昌族", "普米族",
  "塔吉克族", "怒族", "乌孜别克族", "俄罗斯族", "鄂温克族", "德昂族", "保安族", "裕固族", "京族", "塔塔尔族",
  "独龙族", "鄂伦春族", "赫哲族", "门巴族", "珞巴族", "基诺族"
]
const nativeplaces = [
  "北京", "上海", "天津", "重庆", "河北", "山西", "辽宁", "吉林", "黑龙江", "江苏", "浙江", "安徽",
  "福建", "江西", "山东", "河南", "湖北", "湖南", "广东", "海南", "四川", "贵州", "云南", "陕西",
  "甘肃", "青海", "台湾", "内蒙古", "广西", "西藏", "宁夏", "新疆", "香港", "澳门"
]

  const rules = ref({
    userName: [
      { required: true, message: '请输入用户名', trigger: 'blur' },
      { min: 5, message: '最低5位字符', trigger: 'blur' }
    ],
    password: [
      { required: true, message: '请输入用户密码', trigger: 'blur' },
      { min: 6, message: '最低6位字符', trigger: 'blur' }
    ],
    nickName: [{ required: true, message: '请输入用户昵称', trigger: 'blur' }],
    phone: [
      {
        pattern: /^1([38][0-9]|4[014-9]|[59][0-35-9]|6[2567]|7[0-8])\d{8}$/,
        message: '请输入合法手机号',
        trigger: 'blur'
      }
    ],
    email: [
      {
        pattern: /^([0-9A-Za-z\-_.]+)@([0-9a-z]+\.[a-z]{2,3}(\.[a-z]{2})?)$/g,
        message: '请输入正确的邮箱',
        trigger: 'blur'
      }
    ],
    authorityId: [
      { required: true, message: '请选择用户角色', trigger: 'blur' }
    ]
  })
  const userForm = ref(null)

  //更新新的数据到数据库
  const enterAddUserDialog = async () => {
    //userInfo.value.authorityId = userInfo.value.authorityIds[0]
    userForm.value.validate(async (valid) => {
      if (valid) {
        const req = {
          ...userInfo.value
        }
        /*if (dialogFlag.value === 'add') {
          const res = await register(req)
          if (res.code === 0) {
            ElMessage({ type: 'success', message: '创建成功' })
            await getTableData()
            closeAddUserDialog()
          }
        }*/
        if (dialogFlag.value === 'edit') {
          const res = await setZhengshuInfo(req)
          if (res.code === 0) {
            ElMessage({ type: 'success', message: '编辑成功' })
            await getTableData()
            closeAddUserDialog()
          }
        }
      }
    })
  }

  const addUserDialog = ref(false)
  const closeAddUserDialog = () => {
    userForm.value.resetFields()
    //userInfo.value.pic = ''
    //userInfo.value.authorityIds = []
    addUserDialog.value = false
  }

  const dialogFlag = ref('add')

  const addUser = () => {
    dialogFlag.value = 'add'
    addUserDialog.value = true
  }

  const tempAuth = {}
  const changeAuthority = async (row, flag, removeAuth) => {
    if (flag) {
      if (!removeAuth) {
        tempAuth[row.ID] = [...row.authorityIds]
      }
      return
    }
    await nextTick()
    const res = await setUserAuthorities({
      ID: row.ID,
      authorityIds: row.authorityIds
    })
    if (res.code === 0) {
      ElMessage({ type: 'success', message: '角色设置成功' })
    } else {
      if (!removeAuth) {
        row.authorityIds = [...tempAuth[row.ID]]
        delete tempAuth[row.ID]
      } else {
        row.authorityIds = [removeAuth, ...row.authorityIds]
      }
    }
  }

  const openEdit = (row) => {
    dialogFlag.value = 'edit'
    //userInfo.value = JSON.parse(JSON.stringify(row))
    const data = JSON.parse(JSON.stringify(row))
    // 日期格式处理（重要）
    //if (data.age) data.age = new Date(data.age + '-01')
    //if (data.bysj) data.bysj = new Date(data.bysj + '-01')

    userInfo.value = data
    addUserDialog.value = true
  }

  const switchEnable = async (row) => {
    userInfo.value = JSON.parse(JSON.stringify(row))
    await nextTick()
    const req = {
      ...userInfo.value
    }
    const res = await setUserInfo(req)
    if (res.code === 0) {
      ElMessage({
        type: 'success',
        message: `${req.enable === 2 ? '禁用' : '启用'}成功`
      })
      await getTableData()
      userInfo.value.headerImg = ''
      userInfo.value.authorityIds = []
    }
  }

  const zhengshuDetailFunc = (row) => {
  /*router.push({
    name: 'certificateInfo',  // 你注册的路由名称
    query: { id: row.ID }     // 假设 row.ID 是证书主键
  })*/
  const TYPE_CERTIFICATE = 'certificate'
  const queryParams = new URLSearchParams({
      type:TYPE_CERTIFICATE,
      id: row.ID
      //name: row.name,
      //idCard: row.certificatenumber2
    }).toString()

    //window.open(`/business/certificateInfo?${queryParams}`, '_blank')
    const fullPath = `#/layout/business/certificate/certificateInfo?${queryParams}`
    window.open(fullPath, '_blank')
}

const formatDate = (dateStr) => {
  return dateStr ? dayjs(dateStr).format('YYYY-MM-DD HH:mm:ss') : ''
}
</script>

<style lang="scss">
  .header-img-box {
    @apply w-52 h-52 border border-solid border-gray-300 rounded-xl flex justify-center items-center cursor-pointer;
  }
</style>
