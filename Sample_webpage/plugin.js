import {
  Uppy,
  Dashboard,
  ImageEditor,
  Compressor,
  XHRUpload
} from "https://releases.transloadit.com/uppy/v5.2.1/uppy.min.mjs"
// import Japanese from "https://releases.transloadit.com/uppy/locales/v3.3.1/ja_JP.min.js"
// import '@uppy/core/css/style.min.css';
// import '@uppy/dashboard/css/style.min.css';

const Japanese = {
  strings: {
    // browse: 'выберите ;-)',
    dropPasteBoth: 'ここにファイルをドロップするか、貼り付けるか、%{browse}してください',
  },
}

IMParts_Catalog.uppy = {
  optionsSeed: {
    inline: true,
    showProgressDetails: true,
    proudlyDisplayPoweredByUppy: true,
    width: 400,
    height: 200,
    // locale: Uppy.locales.ja_JP

  },
  useImageEditor: true,
  useCompressor: true,

  instantiate: function (targetNode) {
    const nodeId = targetNode.getAttribute('id')
    this.ids.push(nodeId)
    targetNode._im_getComponentId = (function () {
      const theId = nodeId
      return function () {
        return theId
      }
    })()
    targetNode._im_setValue = (function () {
      const theId = nodeId
      return function (str) {
        IMParts_Catalog.uppy.values[theId] = str
      }
    })()
    targetNode._im_getValue = (function () {
      const theId = nodeId
      return function () {
        if (IMParts_Catalog.uppy.values[theId]) {
          return IMParts_Catalog.uppy.values[theId]
        }
        return null
      }
    })()
  },

  ids: [],
  values: {},

  finish: function () {
    for (let i = 0; i < this.ids.length; i++) {
      const targetId = this.ids[i]
      const uppy = new Uppy({locale: Japanese})
      const options = {...IMParts_Catalog.uppy.optionsSeed}
      options.target = `#${targetId}`
      options.locale = Japanese
      uppy.use(Dashboard, options)
      if (IMParts_Catalog.uppy.useImageEditor) {
        uppy.use(ImageEditor, {target: Dashboard})
      }
      if (IMParts_Catalog.uppy.useCompressor) {
        uppy.use(Compressor)
      }
      uppy.use(XHRUpload, {
        endpoint: INTERMediatorOnPage.getEntryPath() + '?access=uploadfile',
        method: "post",
        formData: true,
        limit: 6,
        bundle: true,
        allowedMetaFields: [''],
        // Called again for every retry too.
        async onBeforeRequest(xhr) {
          const cInfo = IMLibContextPool.getContextInfoFromId(targetId, '')
          const keyValue = cInfo.record.split('=')
          const metaData = {
            access: 'uploadfile',
            _im_contextnewrecord: 'uploadfile',
            _im_contextname: cInfo.context.contextName,
            _im_field: cInfo.field,
            _im_keyfield: keyValue[0],
            _im_keyvalue: keyValue[1],
            authuser: IMLibAuthentication.authUser()
          }
          if (IMLibAuthentication.authUser() && IMLibAuthentication.authUser().length > 0) {
            metaData['clientid'] = IMLibAuthentication.clientId()

            if ((IMLibAuthentication.authHashedPassword()
                || IMLibAuthentication.authHashedPassword2m()
                || IMLibAuthentication.authHashedPassword2())
              && IMLibAuthentication.authChallenge) {
              if (IMLibAuthentication.passwordHash < 1.1 && IMLibAuthentication.authHashedPassword()) {
                const shaObj = new jsSHA('SHA-256', 'TEXT')
                shaObj.setHMACKey(IMLibAuthentication.authChallenge, 'TEXT')
                shaObj.update(IMLibAuthentication.authHashedPassword())
                metaData['response'] = shaObj.getHMAC('HEX')
              }
              if (IMLibAuthentication.passwordHash < 1.6 && IMLibAuthentication.authHashedPassword2m()) {
                const shaObj = new jsSHA('SHA-256', 'TEXT')
                shaObj.setHMACKey(IMLibAuthentication.authChallenge, 'TEXT')
                shaObj.update(IMLibAuthentication.authHashedPassword2m())
                metaData['response2m'] = shaObj.getHMAC('HEX')
              }
              if (IMLibAuthentication.passwordHash < 2.1 && IMLibAuthentication.authHashedPassword2()) {
                const shaObj = new jsSHA('SHA-256', 'TEXT')
                shaObj.setHMACKey(IMLibAuthentication.authChallenge, 'TEXT')
                shaObj.update(IMLibAuthentication.authHashedPassword2())
                metaData['response2'] = shaObj.getHMAC('HEX')
              }
            }
            // file.id -> targetId
            uppy.setFileMeta(targetId, metaData);
          }
        },
        async onAfterResponse(xhr) {
          if (xhr.status === 401) {
            token = await getAuthToken();
          }
        }
      })

      /*


            const cInfo = IMLibContextPool.getContextInfoFromId(targetId, '')
            const targetNode = $('#' + targetId + '-fileupload')
            if (targetNode) {
              if (cInfo) { // The element is included in normal (not postonly) context.
                const keyValue = cInfo.record.split('=')
                targetNode.fileupload({
                  dataType: 'json',
                  url: INTERMediatorOnPage.getEntryPath() + '?access=uploadfile',
                  limitConcurrentUploads: 1,
                  //formData: formData,
                  add: (function () {
                    const idValue = targetId
                    return function (e, data) {
                      if (IMParts_Catalog.jquery_fileupload.fileExtRequirements) {
                        let hasMatchExt = false
                        for (const ext of IMParts_Catalog.jquery_fileupload.fileExtRequirements) {
                          if (new RegExp(`\.(${ext})$`, 'i').test(data.files[0].name)) {
                            hasMatchExt = true
                          }
                        }
                        if (!hasMatchExt) {
                          return
                        }
                      }
                      $('#' + idValue + '-filename').text(data.files[0].name)
                      $('#' + idValue + '-filenamearea').css('display', 'block')
                      $('#' + idValue + '-uploadarea').css('display', 'inline-block')
                      $('#' + idValue + '-uploadarea').click(function () {
                        data.submit()
                      })
                      if (IMParts_Catalog.jquery_fileupload.submitAfterSelect) {
                        data.submit()
                        return
                      }
                      const targetFile = data.files[0]
                      const imageReader = new FileReader()
                      imageReader.addEventListener('load', function () {
                        if (IMParts_Catalog.jquery_fileupload.isShowPreview) {
                          document.querySelector('#' + idValue + '-previewarea').style.display = 'block'
                          const another = targetFile.type.indexOf('image') === 0 ? 'iframe' : 'image'
                          document.querySelector('#' + idValue + '-' + another + 'preview').style.display = 'none'
                          const sign = targetFile.type.indexOf('image') === 0 ? 'image' : 'iframe'
                          const previewNode = document.querySelector('#' + idValue + '-' + sign + 'preview')
                          previewNode.src = this.result
                          previewNode.style.display = 'inline'
                        }
                      }, false)
                      imageReader.readAsDataURL(targetFile)
                    }
                  })(),
                  dropZone: $('#' + targetId),
                  // drop: function (e) {
                  //   e.preventDefault()
                  //   console.log('###')
                  // },
                  submit: (function () {
                    const idValue = targetId
                    const cName = cInfo.context.contextName, cField = cInfo.field,
                      keyField = keyValue[0], kv = keyValue[1]
                    return function (e, data) {
                      let fdata = []
                      fdata.push({name: 'access', value: 'uploadfile'})
                      fdata.push({name: '_im_contextnewrecord', value: 'uploadfile'})
                      fdata.push({name: '_im_contextname', value: cName})
                      fdata.push({name: '_im_field', value: cField})
                      fdata.push({name: '_im_keyfield', value: keyField})
                      fdata.push({name: '_im_keyvalue', value: kv})
                      fdata.push({name: 'authuser', value: IMLibAuthentication.authUser()})
                      if (IMLibAuthentication.authUser() && IMLibAuthentication.authUser().length > 0) {
                        fdata.push({name: 'clientid', value: IMLibAuthentication.clientId()})
                        if ((IMLibAuthentication.authHashedPassword()
                            || IMLibAuthentication.authHashedPassword2m()
                            || IMLibAuthentication.authHashedPassword2())
                          && IMLibAuthentication.authChallenge) {
                          if (IMLibAuthentication.passwordHash < 1.1 && IMLibAuthentication.authHashedPassword()) {
                            const shaObj = new jsSHA('SHA-256', 'TEXT')
                            shaObj.setHMACKey(IMLibAuthentication.authChallenge, 'TEXT')
                            shaObj.update(IMLibAuthentication.authHashedPassword())
                            const hmacValue = shaObj.getHMAC('HEX')
                            fdata.push({name: 'response', value: hmacValue})
                          }
                          if (IMLibAuthentication.passwordHash < 1.6 && IMLibAuthentication.authHashedPassword2m()) {
                            const shaObj = new jsSHA('SHA-256', 'TEXT')
                            shaObj.setHMACKey(IMLibAuthentication.authChallenge, 'TEXT')
                            shaObj.update(IMLibAuthentication.authHashedPassword2m())
                            const hmacValue = shaObj.getHMAC('HEX')
                            fdata.push({name: 'response2m', value: hmacValue})
                          }
                          if (IMLibAuthentication.passwordHash < 2.1 && IMLibAuthentication.authHashedPassword2()) {
                            const shaObj = new jsSHA('SHA-256', 'TEXT')
                            shaObj.setHMACKey(IMLibAuthentication.authChallenge, 'TEXT')
                            shaObj.update(IMLibAuthentication.authHashedPassword2())
                            const hmacValue = shaObj.getHMAC('HEX')
                            fdata.push({name: 'response2', value: hmacValue})
                          }
                        } else {
                          fdata.push({name: 'response', value: 'dummydummy'})
                        }
                        // if (IMLibAuthentication.isNativeAuth || IMLibAuthentication.isLDAP) {
                        //   const encrypt = new JSEncrypt()
                        //   encrypt.setKey(INTERMediatorOnPage.publickey)
                        //   fdata.push({
                        //     name: 'cresponse',
                        //     value: encrypt.encrypt(
                        //       INTERMediatorOnPage.authCryptedPassword().substr(0, 220) +
                        //       IMLib.nl_char + INTERMediatorOnPage.authChallenge)
                        //   })
                        // }
                      }
                      data.formData = fdata
                      if (INTERMediatorOnPage.doBeforeValueChange) {
                        INTERMediatorOnPage.doBeforeValueChange(idValue)
                      }
                    }
                  })(),
                  done: (function () {
                    const idValue = targetId
                    const cName = cInfo.context.contextName
                    let updateContext = targetNode[0].parentNode.parentNode.parentNode.getAttribute('data-im-update')
                    updateContext = updateContext ? updateContext : cName
                    return function (e, data) {
                      const result = INTERMediator_DBAdapter.uploadFileAfterSucceed(data.jqXHR.responseText, null, null, true)
                      if (INTERMediatorOnPage.doAfterValueChange) {
                        INTERMediatorOnPage.doAfterValueChange(idValue)
                      }
                      data.jqXHR.abort()
                      if (result) {
                        INTERMediatorLog.flushMessage()
                        if (IMParts_Catalog.jquery_fileupload.fullUpdate) {
                          INTERMediator.construct()
                        } else if (updateContext) {
                          INTERMediator.construct(IMLibContextPool.contextFromName(updateContext))
                        } else {
                          INTERMediator.construct(IMLibContextPool.contextFromName(cName))
                        }
                      }
                    }
                  })(),
                  fail: function (e, data) {
                    window.alert(data.jqXHR.responseText)
                    data.jqXHR.abort()
                  },
                  progressall: (function () {
                    const idValue = targetId
                    return function (e, data) {
                      let progress = parseInt(data.loaded / data.total * 100, 10)
                      $('#' + idValue + '-progress').css('width', progress + '%')
                    }
                  })()
                })
              } else { // For postonly mode.
                if (targetNode) {
                  $('#' + targetId + '-progress').parent().css('display', 'none')
                  $('#' + targetId + '-previewarea').css('display', 'none')
                  targetNode.fileupload({
                    dataType: 'json',
                    // url: INTERMediatorOnPage.getEntryPath() + '?access=uploadfile',
                    limitConcurrentUploads: 1,
                    add: (function () {
                      const idValue = targetId
                      return function (e, data) {
                        const targetFile = data.files[0]
                        if (IMParts_Catalog.jquery_fileupload.fileExtRequirements) {
                          let hasMatchExt = false
                          for (const ext of IMParts_Catalog.jquery_fileupload.fileExtRequirements) {
                            if (new RegExp(`\.(${ext})$`, 'i').test(targetFile.name)) {
                              hasMatchExt = true
                            }
                          }
                          if (!hasMatchExt) {
                            return
                          }
                        }
                        $('#' + idValue + '-filenamearea').css('display', 'block')
                        if (!Array.isArray(IMParts_Catalog.jquery_fileupload.values[idValue])) {
                          const fnStr = $('#' + idValue + '-filename').text()
                          if (fnStr) {
                            $('#' + idValue + '-filename').text(`${fnStr}, ${targetFile.name}`)
                          } else {
                            $('#' + idValue + '-filename').text(targetFile.name)
                          }
                        } else {
                          $('#' + idValue + '-filename').text(targetFile.name)
                        }
                        const imageReader = new FileReader()
                        imageReader.addEventListener('load', function () {
                          if (IMParts_Catalog.jquery_fileupload.isShowPreview) {
                            document.querySelector('#' + idValue + '-previewarea').style.display = 'block'
                            const another = targetFile.type.indexOf('image') === 0 ? 'iframe' : 'image'
                            document.querySelector('#' + idValue + '-' + another + 'preview').style.display = 'none'
                            const sign = targetFile.type.indexOf('image') === 0 ? 'image' : 'iframe'
                            const previewNode = document.querySelector('#' + idValue + '-' + sign + 'preview')
                            previewNode.src = this.result
                            previewNode.style.display = 'inline'
                          }
                          if (IMParts_Catalog.jquery_fileupload.multiFileInPostOnly) {
                            if (!Array.isArray(IMParts_Catalog.jquery_fileupload.values[idValue])) {
                              IMParts_Catalog.jquery_fileupload.values[idValue] = []
                            }
                            IMParts_Catalog.jquery_fileupload.values[idValue].push({
                              file: targetFile,
                              kind: 'attached'
                            })
                          } else {
                            IMParts_Catalog.jquery_fileupload.values[idValue] = {
                              file: targetFile,
                              kind: 'attached'
                            }
                          }
                        }, false)
                        imageReader.readAsDataURL(targetFile)
                      }
                    })(),
                    dropZone: $('#' + targetId),
                    // drop: function (e) {
                    //   e.preventDefault()
                    //   console.log('###')
                    // }
                  })
                }
              }
            }

       */
    }
    this.ids = []
  }
}
