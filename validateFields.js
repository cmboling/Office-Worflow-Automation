const a = _.difference(Object.keys(Some.schema.field).sort(), ['_id', '__v']);
const optionalValidKeys = ['q', 'w'];

function validateIt(objs) {
    _.forEach(objs, obj => {
        const keysToValidate = Object.keys(event).sort();
        const keysFromModel =
            obj.hasOwnProperty('f') && _.get(event, 'ff') === false
                ? _.difference(a, ['someDetail'])
                : a;
        const keyDifferences = _.xor(keysFromModel, keysToValidate).filter(
            key => !optionalValidKeys.includes(key)
        );
        if (!_.isEmpty(keyDifferences)) {
            throw new Error(`Missing/Invalid key(s): '${keyDifferences}'`);
        }
    });
}
