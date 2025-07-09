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
          <el-input v-model="searchInfo.certificate_id" placeholder="毕业证书编号" />
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
        <el-table-column align="left" label="ID" min-width="50" prop="ID" />
        <el-table-column
          align="left"
          label="学员姓名"
          min-width="100"
          prop="name"
        />
        
        <el-table-column prop="gender" label="性别">
          <template #default="{ row }">
            {{ row.gender === 1 ? '男' : row.gender === 2 ? '女' : '未知' }}
          </template>
        </el-table-column>
        
        <el-table-column
          align="left"
          label="培训项目名称"
          min-width="110"
          prop="training_program"
        />

        <el-table-column
          align="left"
          label="身份证号"
          min-width="180"
          prop="id_card_number"
        />
        <el-table-column
          align="left"
          label="证书号"
          min-width="180"
          prop="certificate_id"
        />
        <el-table-column
          align="left"
          label="结业日期"
          min-width="100"
          prop="issue_date"
        />
        <el-table-column
          align="left"
          label="录入人员"
          min-width="100"
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
        label-width="100px"
      >

        <el-form-item label="用户名" prop="name">
          <el-input v-model="userInfo.name" style="width: 200px" />
        </el-form-item>

        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="userInfo.gender">
            <el-radio :label="1">男</el-radio>
            <el-radio :label="2">女</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="身份证号" prop="id_card_number">
          <el-input
            v-model="userInfo.id_card_number"
            style="width: 200px"
            placeholder="请输入18位身份证号码"
          />
        </el-form-item>

        <el-form-item label="证书名称" prop="certificate_name">
          <el-input v-model="userInfo.certificate_name" style="width: 200px" />
        </el-form-item>

        <el-form-item label="证书编号" prop="certificate_id">
          <el-input v-model="userInfo.certificate_id" style="width: 200px" />
        </el-form-item>

        <el-form-item label="培训项目名称" prop="training_program">
          <el-input v-model="userInfo.training_program" style="width: 200px" />
        </el-form-item>

        <el-form-item label="结业日期" prop="issue_date">
          <el-date-picker
            v-model="userInfo.issue_date"
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
    getTrainStuList,
    delTrainStuById,
    setTrainStuInfo
  } from '@/api/user'

  import { getAuthorityList } from '@/api/authority'
  import { setUserInfo, resetPassword } from '@/api/user.js'
  import SelectImage from '@/components/upload/zsCommon.vue'
  //import zhengshuInfo from '@/view/business/certificate/certificateInfo.vue'
  import { nextTick, ref, watch } from 'vue'
  import { ElMessage, ElMessageBox } from 'element-plus'
  import { useAppStore } from "@/pinia";
  import { useRouter } from 'vue-router'

  defineOptions({
    name: 'trainingQuery'
  })

  const appStore = useAppStore()
  const router = useRouter()

  const searchInfo = ref({
    name: '',
    editor: '',
    certificate_id: '',
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
    const table = await getTrainStuList({
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
      const res = await delTrainStuById({ id: row.ID })
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
          const res = await setTrainStuInfo(req)
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
  const TYPE_SCHOOL = 'school'
  const queryParams = new URLSearchParams({
      type:TYPE_SCHOOL,
      id: row.ID
      //name: row.name,
      //idCard: row.certificatenumber2
    }).toString()

    const fullPath = `#/layout/trainingBusiness/training/trainingInfo?${queryParams}`
    window.open(fullPath, '_blank')
}
</script>

<style lang="scss">
  .header-img-box {
    @apply w-52 h-52 border border-solid border-gray-300 rounded-xl flex justify-center items-center cursor-pointer;
  }
</style>
